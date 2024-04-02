from random import randrange, choice
from pandas import DataFrame
from pyarrow import Table
import pyarrow.parquet as pq

from assets import PRODUCTS, ALL_DAYS,CHANNELS, get_channel_distribution,FIRST_NAMES, LAST_NAMES, RESELLERS_TRANSACTIONS, random_date


def generate_main(n=1000000):
    print('Generating transactions')

    trans = []

    for i in range(n):

        product = choice(PRODUCTS)
        
        bought = random_date()
        boughtdate = str(bought)

        qty = randrange(1,6)

        transaction = {
        	       'transaction_id': i,
        	       'customer_id': randrange(1,100000),
                       'product_id': product['product_id'],
                       'amount': product['price'] * qty,
                       'qty': qty,
                       'channel_id': choice([i['channel_id'] for i in CHANNELS]),
                       'bought_date': boughtdate }

        trans.append(transaction)

    generate_parquet_file('main', trans)

def generate_resellers():
    print('Generating resellers')

    generate_parquet_file('resellers', RESELLERS_TRANSACTIONS)

def generate_channels():
    print('Generating channels')

    generate_parquet_file('channels', CHANNELS)


def generate_customers():
    print('Generating customers')

    trans = []
    for i in range(100000):
        first_name = choice(FIRST_NAMES)
        last_name = choice(LAST_NAMES)
        trans.append({'customer_id': i, 'first_name': first_name , 'last_name': last_name, 'email': f'{first_name}.{last_name}@example.com' })

    generate_parquet_file('customers', trans)


def generate_products():
    print('Generating products')

    generate_parquet_file('products', PRODUCTS)



def generate_type1_reseller_data(n=50000):
    print('Generating Type 1 Reseller data')

    export = []

    for resellerid in [1001, 1002]:

        for i in range(n): 

            product = choice(PRODUCTS)

            qty = randrange(1,7)

            boughtdate = str(random_date())

            first_name = choice(FIRST_NAMES)
            last_name = choice(LAST_NAMES)

            transaction = {
                        'Product name': product['name'],
                        'Quantity':  qty,
                        'Total amount': qty * product['price'],
                        'Sales Channel': choice(get_channel_distribution('reseller')),
                        'Customer First Name': first_name,
                        'Customer Last Name': last_name,
                        'Customer Email': f'{first_name}.{last_name}@example.com',
                        'Series City': product['city'],
                        'Created Date': boughtdate,
                        'Reseller ID' : resellerid,
                        'Transaction ID': i
                        
                        
                        }

            export.append(transaction)

    generate_parquet_file('resellers_type1', export)




def generate_type2_reseller_data(n = 50000 ):


    print('Generating Type 2 reseller data')
    export = []

    for resellerid in [1003, 1004]:
        for i in range(n):

            product = choice(PRODUCTS)

            qty = randrange(1,7)

            bought = random_date()

            boughtdate = str(bought).replace('-','')

            first_name = choice(FIRST_NAMES)
            last_name = choice(LAST_NAMES)

            transaction = {
                        'date': boughtdate,
                        'reseller-id':resellerid,
                        'productName': product['name'],
                        'qty' : qty,
                        'totalAmount': qty * product['price'] * 1.0,
                        'salesChannel': choice(get_channel_distribution('reseller')),
                        'customer': {'firstname': first_name, 'lastname': last_name, 'email': f'{first_name}.{last_name}@example.com' },
                        'dateCreated': boughtdate,
                        'seriesCity': product['city'],
                        'Created Date': str(bought),
                        'transactionID': i
                        }
            export.append(transaction)

    generate_parquet_file('resellers_type2', export)

def cleanup(directory, ext):

    import os

    filelist = [ f for f in os.listdir(directory) if f.endswith(ext) ]
    for f in filelist:
        os.remove(os.path.join(directory, f))


def generate_parquet_file(name, records):

    df = DataFrame(records)
    
    table = Table.from_pandas(df)

    pq.write_table(table, f"/shared/parquet/{name}.parquet")

generate_main()
generate_channels()
generate_customers()
generate_products()
generate_resellers()
generate_type1_reseller_data()
generate_type2_reseller_data()

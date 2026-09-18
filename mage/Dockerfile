FROM mageai/mageai:0.9.79

# The image's own dbt is 1.8.7, which is too old to parse the shared model's
# schema.yml. Upgrade it; everything else in the image is left alone.
COPY mage/requirements.txt /tmp/requirements.txt

RUN pip install uv && uv pip install --system -r /tmp/requirements.txt

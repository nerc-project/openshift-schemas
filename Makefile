SCHEMA_MERGED = openshift-api-schema.json
SCHEMA_DIR = schemas

SOURCES = $(shell find $(SCHEMA_DIR) -name '*.json')
PATCHES = $(wildcard patches/*.json) $(wildcard patches/*.yaml)

VERBOSE=-v

all: $(SCHEMA_MERGED)

$(SCHEMA_MERGED): $(SCHEMA_DIR)/kustomization.yaml kustomization.yaml $(SOURCES) $(PATCHES)
	kustomize build | \
		yq -s '{"definitions": [.[].definitions]|add}' > $@ || { rm -f $@; exit 1; }

clean:
	rm -f $(SCHEMA_MERGED)

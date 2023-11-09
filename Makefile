SCHEMA_RAW = openshift-api-schema-raw.json
SCHEMA_MERGED = openshift-api-schema.json
SCHEMA_DIR = schemas

SOURCES = $(shell find $(SCHEMA_DIR) -name '*.json')
PATCHES = $(wildcard patches/*.json) $(wildcard patches/*.yaml)

VERBOSE=-v

all: $(SCHEMA_MERGED)

$(SCHEMA_RAW):
	./schemautil $(VERBOSE) fetch -o $@

$(SCHEMA_DIR)/kustomization.yaml: $(SCHEMA_RAW)
	./schemautil $(VERBOSE) split -d $(SCHEMA_DIR) $<
	./schemautil $(VERBOSE) kustomize  $(SCHEMA_DIR)

$(SCHEMA_MERGED): $(SCHEMA_DIR)/kustomization.yaml kustomization.yaml $(SOURCES) $(PATCHES)
	kustomize build | \
		yq -s '{"definitions": [.[].definitions]|add}' > $@ || { rm -f $@; exit 1; }

clean:
	rm -f $(SCHEMA_MERGED) $(SCHEMA_RAW)

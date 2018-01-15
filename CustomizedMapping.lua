CustomizedMapping = {}
CustomizedMapping.Locations = {};

--Note: The mappings listed are prefix matches. The addon will verify if the location value listed below is the prefix of the location code found in the MARC XML data.
--Since the addon is matching based on prefixes, more specific mappings should be listed first.
--If a mapping code is not found, the code will be used as its location.

-- Example Location Mapping:
-- CustomizedMapping.Locations["finelock"] = "Fine Locked Case";

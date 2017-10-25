DataMapping = {}
DataMapping.Icons = {};
DataMapping.SearchTypes = {};
DataMapping.SourceFields = {};
DataMapping.ImportFields = {};
DataMapping.ImportFields.Bibliographic = {};
DataMapping.ImportFields.Holding = {};
DataMapping.ImportFields.StaticHolding = {};

--Typical Settings that shoudn't need user configuration
DataMapping.LabelName = "Catalog Search";

-- Icons: Aeon
DataMapping.Icons["Aeon"] = {};
DataMapping.Icons["Aeon"]["Search"] = "srch_32x32";
DataMapping.Icons["Aeon"]["Home"] = "home_32x32";
DataMapping.Icons["Aeon"]["Web"] = "web_32x32";
DataMapping.Icons["Aeon"]["Record"] = "record_32x32";
DataMapping.Icons["Aeon"]["Import"] = "impt_32x32";

-- SearchTypes (query strings appended to the base URL)
DataMapping.SearchTypes["Title"] = "?search_field=title_search&q=";
DataMapping.SearchTypes["Author"] = "?search_field=author_search&q=";
DataMapping.SearchTypes["Call Number"] = "?search_field=call_number_xfacet&q=";

-- Source Fields: Aeon
DataMapping.SourceFields["Aeon"] = {};
DataMapping.SourceFields["Aeon"]["Title"] = "ItemTitle";
DataMapping.SourceFields["Aeon"]["Author"] = "ItemAuthor";
DataMapping.SourceFields["Aeon"]["Call Number"] = "CallNumber";
DataMapping.SourceFields["Aeon"]["Catalog Number"] = "ReferenceNumber";


-- Import Fields
DataMapping.ImportFields.Bibliographic["Aeon"] = {
    {
        Field = "ItemTitle", MaxSize = 255,
        Value = "//datafield[@tag='245']/subfield[@code='a']|//datafield[@tag='245']/subfield[@code='b']"
    },
    {
        Field = "ItemAuthor", MaxSize = 255,
        Value = "//datafield[@tag='100']/subfield[@code='a']|//datafield[@tag='100']/subfield[@code='b'],//datafield[@tag='110']/subfield[@code='a']|//datafield[@tag='110']/subfield[@code='b'],//datafield[@tag='111']/subfield[@code='a']|//datafield[@tag='111']/subfield[@code='b']"
    },
    {
        Field ="ItemPublisher", MaxSize = 255,
        Value = "//datafield[@tag='260']/subfield[@code='b']"
    },
    {
        Field ="ItemPlace", MaxSize = 255,
        Value = "//datafield[@tag='260']/subfield[@code='a']"
    },
    {
        Field ="ItemDate", MaxSize = 50,
        Value = "//datafield[@tag='260']/subfield[@code='c']"
    },
    {
        Field ="ItemEdition", MaxSize = 50,
        Value = "//datafield[@tag='250']/subfield[@code='a']"
    },
    {
        Field ="ItemIssue", MaxSize = 255,
        Value = "//datafield[@tag='773']/subfield[@code='g']"
    }
};


DataMapping.ImportFields.Holding["Aeon"] = {
    {
        Field = "ReferenceNumber", MaxSize = 50,
        Value = "ReferenceNumber"
    },
    {
        Field = "CallNumber", MaxSize = 255,
        Value = "CallNumber"
    },
    {
        Field = "Location", MaxSize = 255,
        Value = "Location"
    },
    {
        Field = "SubLocation", MaxSize = 255,
        Value = "LocationCode"
    }
};
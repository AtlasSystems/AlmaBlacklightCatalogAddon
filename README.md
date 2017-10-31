# Alma Blacklight Catalog Search

## Versions
**1.0.0 -** Initial release

**1.1.0 -** Added LocationCode row. Corrected library mapping.

**1.2.0 -** Correct bug that removes a incorrect characters from certain fields when `RemoveTrailingSpecialCharacters` is on.

## Summary
The addon is located within an item record of an Atlas Product. It is found on the `"Catalog Search"` tab. The addon takes information from the fields in the Atlas Product and searches the catalog in the configured ordered. When the item is found, one selects the desired holding in the *Item Grid* below the browser and clicks *Import*. The addon then makes the necessary API calls to the Alma API and imports the item's information into the Atlas Product.

> **Note:** Only records with a valid MMS ID can be imported with this addon. An example of a record that may not have an MMS ID within your catalog is a record coming from an external resource like HathiTrust.

## Settings

> **CatalogURL:** The base URL that the query strings are appended to.
>
> **HomeURL:** Home page of the catalog.
>
> **AutoSearch:** Defines whether the search should be automatically performed when the form opens.
>
>**RemoveTrailingSpecialCharacters:** Defines whether to remove trailing special characters on import or not. The included special characters are "` \/+,.;:-=.`".
>*Examples: `Baton Rouge, La.,` becomes `Baton Rouge, La.`*
>
>**SearchPriorityList:** The fields that should be searched on, in order of search priority. Each field in the string will be checked for a valid corresponding search value in the request, and the first search type with a valid corresponding value will be used. Each search type must be separated by a comma.
>*Default: Catalog Number,Title,Author,Call Number*
>
>**AutoRetrieveItems:** Defines whether or not the addon should automatically retrieve items related to a record being viewed. Disabling this setting can save the site on Alma API calls because it will only make a [Retrieve Holdings List](https://developers.exlibrisgroup.com/alma/apis/bibs/GET/gwPcGly021om4RTvtjbPleCklCGxeYAfEqJOcQOaLEvEGUPgvJFpUQ==/af2fb69d-64f4-42bc-bb05-d8a0ae56936e) call when the button is pressed.
>
>**AlmaAPIURL:** The URL to the Alma API. The API URL is generally the same between sites. (ex. `https://api-na.hosted.exlibrisgroup.com/almaws/v1/`) More information can be found on [Ex Libris' Site](https://developers.exlibrisgroup.com/alma/apis).
>
>**AlmaAPIKey:** API key used for interacting with the Alma API.
>
>**MMS_IDPrefix:** The MMS_ID Prefix are any characters that precede the mms_id of a record in the URL. The addon gets the current record's MMS ID by looking at the URL of the record's page. A typical Blacklight record url is `/catalog/{MMS ID}`, but if your site has anything that precedes the MMS ID, it must be specified in this setting.
>*Example: UPenn's record URL is `/catalog/Franklin_{MMS ID}`, so their MMS_IDPrefix is "`Franklin_` "*

## Buttons
The buttons for the Alma Blacklight Catalog Search addon are located in the *"Catalog Search"* ribbon in the top left of the requests.

>**Back:** Navigate back one page.
>
>**Forward:** Navigate forward one page.
>
>**Stop:** Stop loading the page.
>
>**Refresh:** Refresh the page.
>
>**New Search:** Goes to the home page of the catalog.
>
>**Title:** Performs a title search on the catalog using the contents of the title field.
>
>**Author:** Performs an author search on the catalog using the contents of the author field.
>
>**Call Number:** Performs a call number search on the catalog using the contents of the call number field.
>
>**Catalog Number:** Navigates directly to the item's page on the catalog using the contents of the reference field.
>*Note: If the catalog number is not a valid number, the browser will navigate to a page that does not exist.*
>
>**Retrieve Items:** Retrieves the holding records for that item.
>*Note:* This button will not appear when AutoRetrieveItems is enabled.
>
>**Import:** Imports the selected record in the items grid.

## Data Mappings
Below are the default configurations for the catalog addon. The mappings within `DataMappings.lua` are settings that typically do not have to be modified from site to site. However, these data mappings can be changed to customize the fields, search queries, and xPath queries to the data.

>**Caution:** Be sure to backup the `DataMappings.lua` file before making modifications Incorrectly configured mappings may cause the addon to stop functioning correctly.

### SearchTypes
The query string is appended to the base catalog url (defined in the settings) when performing the corresponding search *(title, author, etc).*

*Default Configuration:*

| Search Type                               | Query String                          |
| ----------------------------------------- | ------------------------------------- |
| DataMapping.SearchTypes["Title"]          | `?search_field=title_search&q=`       |
| DataMapping.SearchTypes["Author"]         | `?search_field=author_search&q=`      |
| DataMapping.SearchTypes["Call Number"]    | `?search_field=call_number_xfacet&q=` |

>**Note:** The *Catalog Number* search type is not listed here because the Catalog Number button goes directly to item page instead of searching the catalog, therefore, the URL is constructed differently.

### Source Fields
The field that the addon reads from to perform the search.

#### Aeon

*Default Configuration:*

| Field                                              | Source Field      |
| -------------------------------------------------- | ----------------- |
| DataMapping.SourceFields["Aeon"]["Title"]          | `ItemTitle`       |
| DataMapping.SourceFields["Aeon"]["Author"]         | `ItemAuthor`      |
| DataMapping.SourceFields["Aeon"]["Call Number"]    | `CallNumber`      |
| DataMapping.SourceFields["Aeon"]["Catalog Number"] | `ReferenceNumber` |

### Bibliographic Import
The information within this data mapping is used to perform the bibliographic api call. The `Field` is the product field that the data will be imported into, `MaxSize` is the maximum character size the data going into the product field can be, and `Value` is the xPath queries to the information.

>**Note:** One may specify multiple xPath queries for a single field by separating them with a comma. The addon will try each xPath query and returns the first successful one.
>
>*Example:* An author can be inside of `100$a and 100$b` or `110$a and 110$b`. To accomplish this, provide an xPath query for the 100 datafields and an xPath query for the 110 datafields separated by a comma.
>```
>//datafield[@tag='100']/subfield[@code='a']|//datafield[@tag='100']/subfield[@code='b'],
>//datafield[@tag='110']/subfield[@code='a']|//datafield[@tag='110']/subfield[@code='b']
>```

### Holding Import
The information within this data mapping is used import the correct information from the items grid. The `Field` is the product field that the data will be imported into, `MaxSize` is the maximum character size the data going into the product field can be, and `Value` is the FieldName of the column within the item grid.

|  Product Field  |      Value      |  Alma API XML Node  |                              Description                              |
| --------------- | --------------- | ------------------- | --------------------------------------------------------------------- |
| ReferenceNumber | ReferenceNumber | mms_id              | The catalog identifier for the record (MMS ID)                        |
| CallNumber      | CallNumber      | call_number         | The item's call number                                                |
| Location        | Location        | location (expanded) | The location name of the item (Configured in `CustomizedMapping.lua`) |
| Sublocation     | LocationCode    | location            | The location code returned by the Alma API                            |
| Library         | Library         | library             | The library where the item is held                                    |

> **Note:** The Holding ID can also be imported by adding another table with a Value of `HoldingId`.

## Customized Mapping
The `CustomizedMapping.lua` file contains the mappings to variables that are more site specific.

### Location Mapping
Maps an item's location code to a full name. If a location mapping isn't given, the addon will display the location code. The location code is taken from the `location` node returned by a [Retrieve Holdings List](https://developers.exlibrisgroup.com/alma/apis/bibs/GET/gwPcGly021om4RTvtjbPleCklCGxeYAfEqJOcQOaLEvEGUPgvJFpUQ==/af2fb69d-64f4-42bc-bb05-d8a0ae56936e) API call.

```lua
CustomizedMapping.Locations["{Location Code}"] = "{Full Location Name}"
```


## FAQ

### How to add or change what information is displayed in the item grid?
There's more holdings information gathered than what is displayed in the item grid. If you wish to display or hide additional columns on the item grid, find the comment `-- Item Grid Column Settings` within the `BuildItemGrid()` function in the *Catalog.lua* file and change the `gridColumn.Visible` variable of the column you wish to modify.

### How to modify what bibliographic information is imported?
To import additional bibliographic fields, add another lua table to the `DataMapping.ImportFields.Bibliographic[{Product Name}]` mapping. To remove a record from the importing remove it from the lua table.

The table takes a `Field` which is the product's field name, a `MaxSize` which is the maximum characters to be imported into the product, and `Value` which is the xPath query to the data returned by the [Retrieve Bibs](https://developers.exlibrisgroup.com/alma/apis/bibs/GET/gwPcGly021q2Z+qBbnVJzw==/af2fb69d-64f4-42bc-bb05-d8a0ae56936e) Alma API call.

## Developers

The addon is developed to support Alma Catalogs that use Blacklight as its discovery layer in [Aeon](https://www.atlas-sys.com/aeon/), [Ares](https://www.atlas-sys.com/ares), and [ILLiad](https://www.atlas-sys.com/illiad/).

Atlas welcomes developers to extend the addon with additional support. All pull requests will be merged and posted to the [addon directories](https://prometheus.atlas-sys.com/display/ILLiadAddons/Addon+Directory).

### Addon Files

* **Config.xml** - The addon configuration file.

* **DataMapping.lua** - The data mapping file contains mappings for the items that do not typically change from site to site.

* **CustomizedMapping.lua** - The a data mapping file that contains settings that are more site specific and likely to change (e.g. location codes).

* **Catalog.lua** - The Catalog.lua is the main file for the addon. It contains the main business logic for importing the data from the Alma API into the Atlas Product.

* **AlmaApi.lua** - The AlmaApi file is used to make the API calls against the Alma API.

* **Utility.lua** - The Utility file is used for common lua functions.
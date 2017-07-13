local AlmaApiInternal = {};
AlmaApiInternal.ApiUrl = nil;
AlmaApiInternal.ApiKey = nil;


local types = {};
types["log4net.LogManager"] = luanet.import_type("log4net.LogManager");
types["System.Net.WebClient"] = luanet.import_type("System.Net.WebClient");
types["System.Text.Encoding"] = luanet.import_type("System.Text.Encoding");
types["System.Xml.XmlTextReader"] = luanet.import_type("System.Xml.XmlTextReader");
types["System.Xml.XmlDocument"] = luanet.import_type("System.Xml.XmlDocument");

-- Create a logger
local log = types["log4net.LogManager"].GetLogger(rootLogger .. ".AlmaApi");

AlmaApi = AlmaApiInternal;

local function GetRequest( requestUrl )
    local webClient = types["System.Net.WebClient"]();
    local response = nil;
    log:Debug("Created Web Client");
    webClient.Encoding = types["System.Text.Encoding"].UTF8;
    webClient.Headers:Add("Accept: application/xml");
    webClient.Headers:Add("Content-Type: application/xml");

    local success, error = pcall(function ()
        response = webClient:DownloadString(requestUrl);
    end);

    webClient:Dispose();
    log:Debug("Disposed Web Client");

    if(success) then
        return response;
    else
        log:InfoFormat("Unable to get response from the request url: {0}", error);
    end
end

local function ReadResponse( responseString )
    if (responseString and #responseString > 0) then

        local responseDocument = types["System.Xml.XmlDocument"]();

        local documentLoaded, error = pcall(function ()
            responseDocument:LoadXml(responseString);
        end);

        if (documentLoaded) then
            return responseDocument;
        else
            log:InfoFormat("Unable to load response content as XML: {0}", error);
            return nil;
        end
    else
        log:Info("Unable to read response content");
    end

    return nil;
end

local function RetrieveHoldingsList( mmsId )
    local requestUrl = AlmaApiInternal.ApiUrl .."bibs/"..
        Utility.URLEncode(mmsId) .."/holdings?apikey=" .. Utility.URLEncode(AlmaApiInternal.ApiKey);
    log:DebugFormat("Request URL: {0}", requestUrl);
    local response = GetRequest(requestUrl);
    log:DebugFormat("response = {0}", response);

    return ReadResponse(response);
end

local function RetrieveBibs( mmsId )
    local requestUrl = AlmaApiInternal.ApiUrl .. "bibs?apikey="..
         Utility.URLEncode(AlmaApiInternal.ApiKey) .. "&mms_id=" .. Utility.URLEncode(mmsId);
    log:DebugFormat("Request URL: {0}", requestUrl);

    local response = GetRequest(requestUrl);
    log:DebugFormat("response = {0}", response);

    return ReadResponse(response);
end

-- Exports
AlmaApi.RetrieveHoldingsList = RetrieveHoldingsList;
AlmaApi.RetrieveBibs = RetrieveBibs;
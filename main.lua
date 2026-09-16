require "import"
import "android.widget.*"
import "android.view.*"
import "android.content.Context"
import "android.content.Intent"
import "android.net.Uri"

local AppConfig = {
    ttsSpeechRate = 1.0,
    autoSpeakText = true,
    showDateInList = true,
    use24HourFormat = false,
    fontSize = 16
}

local favoriteSources = {}

local newsCategories = {
    {
        categoryName = "Favorites",
        sources = favoriteSources
    },
    {
        categoryName = "World News",
        sources = {
            { name = "BBC Urdu (World)", url = "https://www.bbc.com/urdu/index.xml" },
            { name = "BBC News English (World)", url = "https://feeds.bbci.co.uk/news/world/rss.xml" },
            { name = "Al Jazeera Arabic (عربي)", url = "https://www.aljazeera.net/rss" },
            { name = "CNN World News", url = "http://rss.cnn.com/rss/edition_world.rss" },
            { name = "Sky News English (World)", url = "https://feeds.skynews.com/feeds/rss/world.xml" },
            { name = "DW News English", url = "https://rss.dw.com/rdf/rss-en-world" },
            { name = "The Guardian World News", url = "https://www.theguardian.com/world/rss" },
            { name = "Euronews English", url = "https://www.euronews.com/rss?format=mrss&level=theme&name=news" },
            { name = "NPR News", url = "https://feeds.npr.org/1001/rss.xml" },
            { name = "France 24 English", url = "https://www.france24.com/en/rss" },
            { name = "Defense News (Military & War)", url = "https://www.defensenews.com/arc/outboundfeeds/rss/?outputType=xml" }
        }
    },
    {
        categoryName = "Pakistan News",
        sources = {
            { name = "Jang Urdu", url = "https://jang.com.pk/rss/1/1" },
            { name = "Express News Urdu", url = "https://www.express.pk/feed/" },
            { name = "ARY News Urdu", url = "https://urdu.arynews.tv/feed/" },
            { name = "Nawaiwaqt Urdu", url = "https://www.nawaiwaqt.com.pk/rss/latest" },
            { name = "Daily Pakistan Urdu", url = "https://dailypakistan.com.pk/rss/latest" },
            { name = "Dawn News English", url = "https://www.dawn.com/feeds/home" },
            { name = "Geo News English", url = "https://www.geo.tv/rss/1/1" },
            { name = "The Nation English", url = "https://www.nation.com.pk/rss/latest" },
            { name = "Express Tribune English", url = "https://tribune.com.pk/feed/home" },
            { name = "Business Recorder English", url = "https://www.brecorder.com/feeds/latest-news" }
        }
    },
    {
        categoryName = "Entertainment News",
        sources = {
            { name = "BBC Entertainment", url = "https://feeds.bbci.co.uk/news/entertainment_and_arts/rss.xml" },
            { name = "Variety", url = "https://variety.com/feed/" },
            { name = "Hollywood Reporter", url = "https://www.hollywoodreporter.com/feed/" },
            { name = "Rolling Stone", url = "https://www.rollingstone.com/feed/" },
            { name = "Collider", url = "https://collider.com/feed/" },
            { name = "Deadline", url = "https://deadline.com/feed/" }
        }
    },
    {
        categoryName = "Cricket News",
        sources = {
            { name = "NDTV Cricket", url = "https://feeds.feedburner.com/ndtvsports-cricket" },
            { name = "ESPNcricinfo", url = "https://www.espncricinfo.com/rss/content/story/feeds/0.xml" },
            { name = "Cricket365", url = "https://www.cricket365.com/feed/" },
            { name = "BBC Cricket", url = "https://feeds.bbci.co.uk/sport/cricket/rss.xml" },
            { name = "Geo Cricket (Pakistan)", url = "https://www.geo.tv/rss/1/5" },
            { name = "Sky Sports Cricket", url = "https://www.skysports.com/rss/12123" }
        }
    },
    {
        categoryName = "Sports News",
        sources = {
            { name = "BBC Sport (All Sports)", url = "https://feeds.bbci.co.uk/sport/rss.xml" },
            { name = "Sky Sports News", url = "https://www.skysports.com/rss/12040" },
            { name = "Yahoo Sports", url = "https://sports.yahoo.com/rss/" }
        }
    },
    {
        categoryName = "Business & Finance",
        sources = {
            { name = "BBC Business News", url = "https://feeds.bbci.co.uk/news/business/rss.xml" },
            { name = "CNBC Business", url = "https://www.cnbc.com/id/10000115/device/rss/rss.html" },
            { name = "Investing.com News", url = "https://www.investing.com/rss/news.rss" }
        }
    },
    {
        categoryName = "Health & Fitness",
        sources = {
            { name = "BBC Health", url = "https://feeds.bbci.co.uk/news/health/rss.xml" },
            { name = "MedicineNet Daily Health News", url = "https://www.medicinenet.com/rss/dailyhealth.xml" },
            { name = "MedPage Today", url = "https://www.medpagetoday.com/rss/headlines.xml" }
        }
    },
    {
        categoryName = "Science & Space",
        sources = {
            { name = "BBC Science & Environment", url = "https://feeds.bbci.co.uk/news/science_and_environment/rss.xml" },
            { name = "NASA Breaking News", url = "https://www.nasa.gov/rss/dyn/breaking_news.rss" },
            { name = "ScienceDaily News", url = "https://www.sciencedaily.com/rss/all.xml" }
        }
    },
    {
        categoryName = "Technology News",
        sources = {
            { name = "BBC Tech English", url = "https://feeds.bbci.co.uk/news/technology/rss.xml" },
            { name = "TechCrunch", url = "https://techcrunch.com/feed/" },
            { name = "Wired News", url = "https://www.wired.com/feed/rss" },
            { name = "The Verge", url = "https://www.theverge.com/rss/index.xml" },
            { name = "CNET News", url = "https://www.cnet.com/rss/news/" }
        }
    },
    {
        categoryName = "India News",
        sources = {
            { name = "BBC Hindi", url = "https://feeds.bbci.co.uk/hindi/rss.xml" },
            { name = "BBC Bengali", url = "https://feeds.bbci.co.uk/bengali/rss.xml" },
            { name = "BBC Tamil", url = "https://feeds.bbci.co.uk/tamil/rss.xml" },
            { name = "BBC Telugu", url = "https://feeds.bbci.co.uk/telugu/rss.xml" },
            { name = "BBC Gujarati", url = "https://feeds.bbci.co.uk/gujarati/rss.xml" },
            { name = "BBC Marathi", url = "https://feeds.bbci.co.uk/marathi/rss.xml" },
            { name = "BBC Punjabi", url = "https://feeds.bbci.co.uk/punjabi/rss.xml" }
        }
    },
    {
        categoryName = "Bangladesh News",
        sources = {
            { name = "BBC Bengali (Bangladesh)", url = "https://feeds.bbci.co.uk/bengali/rss.xml" },
            { name = "Prothom Alo (English)", url = "https://en.prothomalo.com/feed" },
            { name = "The Daily Star (English)", url = "https://www.thedailystar.net/frontpage/rss.xml" }
        }
    },
    {
        categoryName = "Afghanistan News",
        sources = {
            { name = "BBC Pashto", url = "https://feeds.bbci.co.uk/pashto/rss.xml" },
            { name = "BBC Dari", url = "https://feeds.bbci.co.uk/persian/afghanistan/rss.xml" },
            { name = "Khaama Press (English)", url = "https://www.khaama.com/feed/" },
            { name = "Ariananews (English)", url = "https://www.ariananews.af/feed/" }
        }
    }
}

local function saveStorage(key, value)
    pcall(function()
        local ctx = service.getContext()
        local sp = ctx.getSharedPreferences("news_app_prefs", Context.MODE_PRIVATE)
        local editor = sp.edit()
        editor.putString(key, tostring(value))
        editor.commit()
    end)
end

local function readStorage(key, defaultVal)
    local result = defaultVal
    pcall(function()
        local ctx = service.getContext()
        local sp = ctx.getSharedPreferences("news_app_prefs", Context.MODE_PRIVATE)
        local val = sp.getString(key, nil)
        if val ~= nil then
            result = val
        end
    end)
    return result
end

local savedCat = tonumber(readStorage("selected_category_index", "3")) or 3
if savedCat < 1 or savedCat > #newsCategories then
    savedCat = 3
end
local selectedCategoryIndex = savedCat

local showCategoryMenu
local showMainMenu
local showSettingsMenu

local function isFavorite(source)
    if not source then return false, 0 end
    for i, fav in ipairs(favoriteSources) do
        if fav.url == source.url then
            return true, i
        end
    end
    return false, 0
end

local function toggleFavorite(source)
    if not source then return end
    local fav, index = isFavorite(source)
    if fav then
        table.remove(favoriteSources, index)
        service.speak("Removed from favorites")
    else
        table.insert(favoriteSources, { name = source.name, url = source.url })
        service.speak("Added to favorites")
    end
end

local function copyToClipboard(text)
    if service and service.copy then
        service.copy(text or "")
        service.speak("Copied to clipboard")
        return
    end
    
    pcall(function()
        local ctx = service.getContext()
        local cm = ctx.getSystemService(Context.CLIPBOARD_SERVICE)
        local cd = android.content.ClipData.newPlainText("News Text", text or "")
        cm.setPrimaryClip(cd)
        service.speak("Copied to clipboard")
    end)
end

local function openWhatsApp(number)
    pcall(function()
        local ctx = service.getContext()
        local url = "https://api.whatsapp.com/send?phone=" .. number
        local intent = Intent(Intent.ACTION_VIEW)
        intent.setData(Uri.parse(url))
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        ctx.startActivity(intent)
    end)
end

local function cleanText(text)
    if not text then return "" end
    text = text:gsub("<!%[CDATA%[(.-)%]%]>", "%1")
    text = text:gsub("<script.-</script>", "")
    text = text:gsub("<style.-</style>", "")
    text = text:gsub("<noscript.-</noscript>", "")
    text = text:gsub("<iframe.-</iframe>", "")
    text = text:gsub("<svg.-</svg>", "")
    text = text:gsub("<header.-</header>", "")
    text = text:gsub("<footer.-</footer>", "")
    text = text:gsub("<nav.-</nav>", "")
    text = text:gsub("<aside.-</aside>", "")
    text = text:gsub("%b{}", "")
    text = text:gsub("<[^>]+>", "")
    text = text:gsub("data%-[%w%-_]+=\"[^\"]*\"", "")
    text = text:gsub("&#8230;", "...")
    text = text:gsub("&#8211;", "-")
    text = text:gsub("&#8212;", "—")
    text = text:gsub("&#8216;", "'")
    text = text:gsub("&#8217;", "'")
    text = text:gsub("&#8220;", '"')
    text = text:gsub("&#8221;", '"')
    text = text:gsub("&#x3D;", "=")
    text = text:gsub("&amp;", "&")
    text = text:gsub("&lt;", "<")
    text = text:gsub("&gt;", ">")
    text = text:gsub("&quot;", '"')
    text = text:gsub("&#39;", "'")
    text = text:gsub("&nbsp;", " ")
    text = text:gsub("&#%d+;", "")
    
    text = text:gsub("https?://%S+", "")
    text = text:gsub("http://%S+", "")
    text = text:gsub("ftp://%S+", "")
    text = text:gsub("www%.%S+", "")
    text = text:gsub("[%w%._%%%-]+@[%w%._%%%-]+%.%a%a+", "")
    
    text = text:gsub("• Source: CNN %s*", "")
    text = text:gsub("Scan the QR code to download the CNN app on Google Play%.?", "")
    text = text:gsub("Listen to CNN%s*", "")
    text = text:gsub("Follow CNN on%s*%S*", "")
    text = text:gsub("Sign up for CNN's%s*%S*", "")
    text = text:gsub("Follow the latest business news here or read through the updates below%.?", "")
    text = text:gsub("Follow the latest business news here%.?", "")
    text = text:gsub("read through the updates below%.?", "")
    text = text:gsub("Our live coverage for the day has ended%.?", "")
    
    text = text:gsub("Accessibility links.-Get NPR%+ ", "")
    text = text:gsub("Expand/collapse submenu.-Music ", "")
    text = text:gsub("Expand/collapse submenu.-Shows ", "")
    text = text:gsub("More Podcasts & Shows.-Get NPR%+ ", "")
    text = text:gsub("NPR does not offer or accept money for coverage.-$", "")
    text = text:gsub("Only on NPR.-tracked him down", "")
    text = text:gsub("hide caption", "")

    text = text:gsub("%s+", " ")
    return text:match("^%s*(.-)%s*$") or ""
end

local function formatDateTime(dateStr)
    if not dateStr or dateStr == "" then return "" end
    
    local h, m, s, ampm = dateStr:match("(%d%d?):(%d%d?):?(%d?%d?)%s*([AP]M)")
    if h and m and ampm then
        local hour = tonumber(h)
        if AppConfig.use24HourFormat then
            if ampm:upper() == "PM" and hour < 12 then
                hour = hour + 12
            elseif ampm:upper() == "AM" and hour == 12 then
                hour = 0
            end
            local formattedTime = string.format("%02d:%02d", hour, tonumber(m))
            return dateStr:gsub("%d%d?:%d%d?:?%d?%d?%s*[AP]M", formattedTime)
        else
            return dateStr
        end
    end

    local h24, m24 = dateStr:match("(%d%d?):(%d%d)")
    if h24 and m24 and not ampm then
        local hour = tonumber(h24)
        if not AppConfig.use24HourFormat then
            local period = "AM"
            if hour >= 12 then
                period = "PM"
                if hour > 12 then hour = hour - 12 end
            elseif hour == 0 then
                hour = 12
            end
            local formattedTime = string.format("%d:%02d %s", hour, tonumber(m24), period)
            return dateStr:gsub("%d%d?:%d%d", formattedTime)
        else
            return dateStr
        end
    end

    return dateStr
end

local months = {
    Jan = 1, Feb = 2, Mar = 3, Apr = 4, May = 5, Jun = 6,
    Jul = 7, Aug = 8, Sep = 9, Oct = 10, Nov = 11, Dec = 12,
    January = 1, February = 2, March = 3, April = 4, May = 5, June = 6,
    July = 7, August = 8, September = 9, October = 10, November = 11, December = 12
}

local function parseDateToTimestamp(dateStr)
    if not dateStr or dateStr == "" then return 0 end
    
    local day, monthStr, year, hour, min, sec = dateStr:match("(%d+)%s+(%a+)%s+(%d%d%d%d)%s+(%d%d?):(%d%d):?(%d?%d?)")
    if day and monthStr and year and hour and min then
        local month = months[monthStr:sub(1, 3)] or 1
        return os.time({
            year = tonumber(year),
            month = month,
            day = tonumber(day),
            hour = tonumber(hour),
            min = tonumber(min),
            sec = tonumber(sec ~= "" and sec or 0)
        })
    end
    
    local y, m, d, h, mn, s = dateStr:match("(%d%d%d%d)%-(%d%d)%-(%d%d)T(%d%d):(%d%d):?(%d?%d?)")
    if y and m and d and h and mn then
        return os.time({
            year = tonumber(y),
            month = tonumber(m),
            day = tonumber(d),
            hour = tonumber(hour),
            min = tonumber(mn),
            sec = tonumber(s ~= "" and s or 0)
        })
    end
    
    return 0
end

local function parseRSS(xmlData)
    local items = {}
    if not xmlData or xmlData == "" then return items end

    for itemXml in xmlData:gmatch("<item.->(.-)</item>") do
        local title = itemXml:match("<title.->(.-)</title>") or ""
        local contentEncoded = itemXml:match("<content:encoded.->(.-)</content:encoded>") or ""
        local description = itemXml:match("<description.->(.-)</description>") or ""
        local rawPubDate = itemXml:match("<pubDate.->(.-)</pubDate>") or itemXml:match("<dc:date.->(.-)</dc:date>") or ""
        
        local rawLink = itemXml:match("<link.->(.-)</link>") or itemXml:match("<guid.->(.-)</guid>") or ""
        rawLink = rawLink:gsub("<!%[CDATA%[(.-)%]%]>", "%1")
        local link = rawLink:match("(https?://%S+)") or rawLink:match("(www%.%S+)") or ""

        local articleBody = contentEncoded ~= "" and contentEncoded or description
        local timestamp = parseDateToTimestamp(rawPubDate)
        
        title = cleanText(title)
        articleBody = cleanText(articleBody)
        local pubDate = formatDateTime(cleanText(rawPubDate))

        if title ~= "" then
            table.insert(items, {
                title = title,
                description = articleBody,
                pubDate = pubDate,
                timestamp = timestamp,
                link = link
            })
        end
    end

    if #items == 0 then
        for itemXml in xmlData:gmatch("<entry.->(.-)</entry>") do
            local title = itemXml:match("<title.->(.-)</title>") or ""
            local description = itemXml:match("<content.->(.-)</content>") or itemXml:match("<summary.->(.-)</summary>") or ""
            local rawPubDate = itemXml:match("<published.->(.-)</published>") or itemXml:match("<updated.->(.-)</updated>") or ""
            
            local rawLink = itemXml:match("<link.-href=\"(.-)\".->") or itemXml:match("<link.->(.-)</link>") or ""
            rawLink = rawLink:gsub("<!%[CDATA%[(.-)%]%]>", "%1")
            local link = rawLink:match("(https?://%S+)") or rawLink:match("(www%.%S+)") or ""

            local timestamp = parseDateToTimestamp(rawPubDate)
            title = cleanText(title)
            description = cleanText(description)
            local pubDate = formatDateTime(cleanText(rawPubDate))

            if title ~= "" then
                table.insert(items, {
                    title = title,
                    description = description,
                    pubDate = pubDate,
                    timestamp = timestamp,
                    link = link
                })
            end
        end
    end

    table.sort(items, function(a, b)
        if a.timestamp ~= b.timestamp then
            return a.timestamp > b.timestamp
        end
        return false
    end)

    return items
end

local function fetchUrl(url, callback)
    local headers = {
        ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36",
        ["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
        ["Accept-Language"] = "en-US,en;q=0.9"
    }
    
    Http.get(url, nil, "utf-8", headers, function(code, body)
        if (code == 200 or code == 301 or code == 302) and body and body ~= "" then
            callback(body)
        else
            Http.get(url, function(c, b)
                if b and b ~= "" then
                    callback(b)
                else
                    callback(nil)
                end
            end)
        end
    end)
end

local function parseWebParagraphs(html, sourceName)
    if not html or html == "" then return "" end

    local mainArticle = html
    if sourceName == "NDTV Cricket" then
        mainArticle = html:match('<div[^>]*class="[^"]*ins_storybody[^"]*"[^>]*>(.-)</div>%s*<div')
            or html:match('<div[^>]*class="[^"]*ins_storybody[^"]*"[^>]*>(.-)</div>')
            or html:match('<div[^>]*id="[^"]*ins_storybody[^"]*"[^>]*>(.-)</div>')
            or html:match('<div[^>]*class="[^"]*sp%-cn[^"]*"[^>]*>(.-)</div>')
            or html:match('<div[^>]*class="[^"]*story__content[^"]*"[^>]*>(.-)</div>')
            or html:match('<div[^>]*class="[^"]*story_content[^"]*"[^>]*>(.-)</div>')
            or html:match('<div[^>]*class="[^"]*pst%-cnt[^"]*"[^>]*>(.-)</div>')
            or html:match('<article[^>]*>(.-)</article>')
            or html
    elseif sourceName == "Jang Urdu" then
        mainArticle = html:match('<div class="detail_content[^"]*">(.-)</div>%s*</div>')
            or html:match('<div class="detail_content[^"]*">(.-)</div>')
            or html:match('<div class="detail_box[^"]*">(.-)</div>')
            or html:match('<div class="detail_section[^"]*">(.-)</div>')
            or html
    elseif sourceName == "Express News Urdu" then
        mainArticle = html:match('<span class="story%-text[^"]*">(.-)</span>')
            or html:match('<div class="story%-text[^"]*">(.-)</div>')
            or html:match('<div class="story_details[^"]*">(.-)</div>')
            or html:match('<div class="story_content[^"]*">(.-)</div>')
            or html:match('<div class="content%-area[^"]*">(.-)</div>')
            or html
    elseif sourceName == "Geo News English" or sourceName == "Geo Cricket (Pakistan)" then
        mainArticle = html:match('<div class="content%-area[^"]*">(.-)<div class="sidebar')
            or html:match('<div class="content%-area[^"]*">(.-)</div>%s*</div>')
            or html:match('<div class="content%-area[^"]*">(.-)</div>')
            or html:match('<div class="story_area[^"]*">(.-)</div>')
            or html:match('<div class="story_details[^"]*">(.-)</div>')
            or html:match('<div class="news%-detail[^"]*">(.-)</div>')
            or html
    elseif sourceName == "Nawaiwaqt Urdu" then
        mainArticle = html:match('<div class="detail_text[^"]*">(.-)</div>')
            or html:match('<div class="news%-detail[^"]*">(.-)</div>')
            or html:match('<div class="story%-detail[^"]*">(.-)</div>')
            or html:match('<div class="story%-content[^"]*">(.-)</div>')
            or html:match('<div class="content%-area[^"]*">(.-)</div>')
            or html
    elseif sourceName == "The Nation English" then
        mainArticle = html:match('<div class="story%-content[^"]*">(.-)</div>%s*</div>')
            or html:match('<div class="story%-content[^"]*">(.-)</div>')
            or html:match('<div class="story%-details[^"]*">(.-)</div>')
            or html:match('<div class="detail_content[^"]*">(.-)</div>')
            or html:match('<div class="post%-content[^"]*">(.-)</div>')
            or html
    elseif sourceName == "Express Tribune English" then
        mainArticle = html:match('<div class="story%-text[^"]*">(.-)</div>%s*</div>')
            or html:match('<div class="story%-text[^"]*">(.-)</div>')
            or html:match('<div class="story_details[^"]*">(.-)</div>')
            or html:match('<div class="story%-detail[^"]*">(.-)</div>')
            or html:match('<span class="story%-text[^"]*">(.-)</span>')
            or html:match('<div class="story_content[^"]*">(.-)</div>')
            or html
    else
        mainArticle = html:match('<div class="detail_content[^"]*">(.-)</div>%s*</div>')
            or html:match('<div class="detail_content[^"]*">(.-)</div>')
            or html:match('<div class="detail_box[^"]*">(.-)</div>')
            or html:match('<div class="detail_section[^"]*">(.-)</div>')
            or html:match('<div class="story%-content[^"]*">(.-)</div>')
            or html:match('<div class="story%-text[^"]*">(.-)</div>')
            or html:match('<article[^>]*>(.-)</article>') 
            or html:match('<main[^>]*>(.-)</main>') 
            or html:match('<div id="maincontent"[^>]*>(.-)</div>') 
            or html:match('<div class="story[^"]*">(.-)</div>')
            or html:match('<div class="article[^"]*">(.-)</div>')
            or html:match('<div class="post[^"]*">(.-)</div>')
            or html:match('<div class="content[^"]*">(.-)</div>')
            or html:match('<body[^>]*>(.-)</body>') 
            or html
    end
    
    mainArticle = mainArticle:gsub("<header.-</header>", "")
    mainArticle = mainArticle:gsub("<footer.-</footer>", "")
    mainArticle = mainArticle:gsub("<nav.-</nav>", "")
    mainArticle = mainArticle:gsub("<aside.-</aside>", "")
    mainArticle = mainArticle:gsub("<script.-</script>", "")
    mainArticle = mainArticle:gsub("<style.-</style>", "")
    mainArticle = mainArticle:gsub("<form.-</form>", "")
    mainArticle = mainArticle:gsub("<figure.-</figure>", "")
    mainArticle = mainArticle:gsub("<figcaption.-</figcaption>", "")
    
    local paragraphs = {}
    local seen = {}

    local function addPara(text)
        local cleaned = cleanText(text)
        if #cleaned > 15 and not seen[cleaned] then
            if not cleaned:find("Accessibility links") and not cleaned:find("Expand/collapse") and not cleaned:find("NPR does not offer") and not cleaned:find("Access Denied") then
                seen[cleaned] = true
                table.insert(paragraphs, cleaned)
            end
        end
    end

    for p in mainArticle:gmatch("<p[^>]*>(.-)</p>") do
        addPara(p)
    end

    if #paragraphs < 2 then
        for div in mainArticle:gmatch('<div[^>]*class="[^"]*paragraph[^"]*"[^>]*>(.-)</div>') do
            addPara(div)
        end
    end

    if #paragraphs < 2 then
        for div in mainArticle:gmatch('<div[^>]*class="[^"]*text[^"]*"[^>]*>(.-)</div>') do
            addPara(div)
        end
    end

    if #paragraphs < 2 then
        for div in mainArticle:gmatch('<div[^>]*itemprop="articleBody"[^>]*>(.-)</div>') do
            addPara(div)
        end
    end

    if #paragraphs < 2 then
        for block in mainArticle:gmatch("<div[^>]*>(.-)</div>") do
            if not block:find("<div") then
                addPara(block)
            end
        end
    end

    if #paragraphs > 0 then
        return table.concat(paragraphs, "\n\n")
    end
    
    return cleanText(mainArticle)
end

local function showNewsList(sourceName, newsUrl)
    service.speak("Fetching news from " .. sourceName)

    fetchUrl(newsUrl, function(response)
        if not response or response == "" then
            service.speak("Failed to fetch news. Network error.")
            return
        end

        local newsItems = parseRSS(response)

        if #newsItems == 0 then
            service.speak("No news articles found.")
            return
        end

        local titles = {}
        for i, item in ipairs(newsItems) do
            local displayTitle = item.title
            if AppConfig.showDateInList and item.pubDate ~= "" then
                displayTitle = displayTitle .. " (" .. item.pubDate .. ")"
            end
            table.insert(titles, displayTitle)
        end

        local newsDlg = LuaDialog()
        newsDlg.setTitle(sourceName)

        local context = service.getContext()
        local mainLayout = LinearLayout(context)
        mainLayout.setOrientation(LinearLayout.VERTICAL)
        mainLayout.setPadding(30, 30, 30, 30)

        local listView = ListView(context)
        local adapter = ArrayAdapter(context, android.R.layout.simple_list_item_1, titles)
        listView.setAdapter(adapter)

        local layoutParams = LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT,
            0,
            1.0
        )
        listView.setLayoutParams(layoutParams)

        local refreshBtn = Button(context)
        refreshBtn.setText("Refresh")
        refreshBtn.setTextSize(AppConfig.fontSize)
        refreshBtn.setOnClickListener(View.OnClickListener{
            onClick = function()
                newsDlg.dismiss()
                showNewsList(sourceName, newsUrl)
            end
        })

        local backBtn = Button(context)
        backBtn.setText("Go Back")
        backBtn.setTextSize(AppConfig.fontSize)
        backBtn.setOnClickListener(View.OnClickListener{
            onClick = function()
                newsDlg.dismiss()
                showCategoryMenu()
            end
        })

        mainLayout.addView(listView)
        mainLayout.addView(refreshBtn)
        mainLayout.addView(backBtn)

        listView.setOnItemClickListener(AdapterView.OnItemClickListener{
            onItemClick = function(parent, view, position, id)
                local selectedItem = newsItems[position + 1]
                
                local function displayArticle(bodyContent)
                    local fullText = selectedItem.title
                    if selectedItem.pubDate ~= "" then
                        fullText = fullText .. "\nDate and Time: " .. selectedItem.pubDate
                    end
                    
                    if bodyContent and bodyContent ~= "" then
                        fullText = fullText .. "\n\n" .. bodyContent
                    end
                    
                    fullText = cleanText(fullText)
                    
                    local detailDlg = LuaDialog()
                    detailDlg.setTitle(sourceName)

                    local contextDetail = service.getContext()
                    local detailLayout = LinearLayout(contextDetail)
                    detailLayout.setOrientation(LinearLayout.VERTICAL)
                    detailLayout.setPadding(30, 30, 30, 30)

                    local scrollView = ScrollView(contextDetail)
                    local scrollViewParams = LinearLayout.LayoutParams(
                        LinearLayout.LayoutParams.MATCH_PARENT,
                        0,
                        1.0
                    )
                    scrollView.setLayoutParams(scrollViewParams)

                    local textView = TextView(contextDetail)
                    textView.setText(fullText)
                    textView.setTextSize(AppConfig.fontSize)
                    textView.setPadding(10, 10, 10, 20)
                    textView.setFocusable(true)
                    textView.setFocusableInTouchMode(true)

                    scrollView.addView(textView)

                    local copyBtn = Button(contextDetail)
                    copyBtn.setText("Copy")
                    copyBtn.setTextSize(AppConfig.fontSize - 2)
                    copyBtn.setOnClickListener(function()
                        copyToClipboard(fullText)
                    end)

                    local closeBtn = Button(contextDetail)
                    closeBtn.setText("Go Back")
                    closeBtn.setTextSize(AppConfig.fontSize - 2)
                    closeBtn.setOnClickListener(function()
                        detailDlg.dismiss()
                    end)

                    detailLayout.addView(scrollView)
                    detailLayout.addView(copyBtn)
                    detailLayout.addView(closeBtn)
                    
                    detailDlg.setView(detailLayout)
                    detailDlg.show()

                    textView.post(Runnable({
                        run = function()
                            textView.requestFocus()
                            if AppConfig.autoSpeakText then
                                service.speak(fullText)
                            end
                        end
                    }))
                end

                local itemLink = selectedItem.link or ""
                if itemLink ~= "" and (itemLink:find("^https?://") or itemLink:find("^www%.")) then
                    if not itemLink:find("^https?://") then
                        itemLink = "https://" .. itemLink
                    end
                    if sourceName == "NDTV Cricket" and itemLink:find("sports%.ndtv%.com") then
                        itemLink = itemLink:gsub("https://sports%.ndtv%.com", "https://ndtv.com")
                    end
                    service.speak("Loading full article...")
                    fetchUrl(itemLink, function(webHtml)
                        if webHtml and webHtml ~= "" and not webHtml:find("Access Denied") then
                            local parsedContent = parseWebParagraphs(webHtml, sourceName)
                            if parsedContent and #parsedContent > 20 and not parsedContent:find("Access Denied") then
                                displayArticle(parsedContent)
                                return
                            end
                        end
                        displayArticle(cleanText(selectedItem.description))
                    end)
                else
                    displayArticle(cleanText(selectedItem.description))
                end
            end
        })

        newsDlg.setView(mainLayout)
        newsDlg.show()
    end)
end

showSettingsMenu = function()
    local setDlg = LuaDialog()
    setDlg.setTitle("Settings")

    local context = service.getContext()
    local mainLayout = LinearLayout(context)
    mainLayout.setOrientation(LinearLayout.VERTICAL)
    mainLayout.setPadding(30, 30, 30, 30)

    local autoSpeakCB = CheckBox(context)
    autoSpeakCB.setText("Auto Speak News Details")
    autoSpeakCB.setTextSize(AppConfig.fontSize)
    autoSpeakCB.setChecked(AppConfig.autoSpeakText)
    autoSpeakCB.setOnCheckedChangeListener(CompoundButton.OnCheckedChangeListener{
        onCheckedChanged = function(buttonView, isChecked)
            AppConfig.autoSpeakText = isChecked
        end
    })

    local showDateCB = CheckBox(context)
    showDateCB.setText("Show Publication Date in List")
    showDateCB.setTextSize(AppConfig.fontSize)
    showDateCB.setChecked(AppConfig.showDateInList)
    showDateCB.setOnCheckedChangeListener(CompoundButton.OnCheckedChangeListener{
        onCheckedChanged = function(buttonView, isChecked)
            AppConfig.showDateInList = isChecked
        end
    })

    local timeFormatLabel = TextView(context)
    timeFormatLabel.setText("Time Format:")
    timeFormatLabel.setTextSize(AppConfig.fontSize)
    timeFormatLabel.setPadding(0, 15, 0, 5)

    local timeFormatOptions = {"12-Hour Format (AM/PM)", "24-Hour Format"}
    local timeFormatSpinner = Spinner(context)
    local timeFormatAdapter = ArrayAdapter(context, android.R.layout.simple_spinner_item, timeFormatOptions)
    timeFormatAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
    timeFormatSpinner.setAdapter(timeFormatAdapter)
    timeFormatSpinner.setSelection(AppConfig.use24HourFormat and 1 or 0)

    timeFormatSpinner.setOnItemSelectedListener(AdapterView.OnItemSelectedListener{
        onItemSelected = function(parent, view, position, id)
            AppConfig.use24HourFormat = (position == 1)
        end,
        onNothingSelected = function(parent)
        end
    })

    local fontLabel = TextView(context)
    fontLabel.setText("Text Size:")
    fontLabel.setTextSize(AppConfig.fontSize)
    fontLabel.setPadding(0, 15, 0, 5)

    local fontOptions = {"Small (14sp)", "Medium (16sp)", "Large (18sp)", "Extra Large (20sp)"}
    local fontValues = {14, 16, 18, 20}
    local fontSpinner = Spinner(context)
    local fontAdapter = ArrayAdapter(context, android.R.layout.simple_spinner_item, fontOptions)
    fontAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
    fontSpinner.setAdapter(fontAdapter)
    
    for idx, val in ipairs(fontValues) do
        if val == AppConfig.fontSize then
            fontSpinner.setSelection(idx - 1)
            break
        end
    end

    fontSpinner.setOnItemSelectedListener(AdapterView.OnItemSelectedListener{
        onItemSelected = function(parent, view, position, id)
            AppConfig.fontSize = fontValues[position + 1]
        end,
        onNothingSelected = function(parent)
        end
    })

    local saveBtn = Button(context)
    saveBtn.setText("Save & Go Back")
    saveBtn.setTextSize(AppConfig.fontSize)
    saveBtn.setOnClickListener(View.OnClickListener{
        onClick = function()
            setDlg.dismiss()
            service.speak("Settings Saved")
            showMainMenu()
        end
    })

    mainLayout.addView(autoSpeakCB)
    mainLayout.addView(showDateCB)
    mainLayout.addView(timeFormatLabel)
    mainLayout.addView(timeFormatSpinner)
    mainLayout.addView(fontLabel)
    mainLayout.addView(fontSpinner)
    mainLayout.addView(saveBtn)

    setDlg.setView(mainLayout)
    setDlg.show()
end

showCategoryMenu = function()
    local catDlg = LuaDialog()
    catDlg.setTitle("Select Category & Channel")

    local context = service.getContext()
    local mainLayout = LinearLayout(context)
    mainLayout.setOrientation(LinearLayout.VERTICAL)
    mainLayout.setPadding(30, 30, 30, 30)

    local categoryNames = {}
    for i, cat in ipairs(newsCategories) do
        table.insert(categoryNames, cat.categoryName)
    end

    local spinner = Spinner(context)
    local spinnerAdapter = ArrayAdapter(context, android.R.layout.simple_spinner_item, categoryNames)
    spinnerAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
    spinner.setAdapter(spinnerAdapter)
    spinner.setSelection(selectedCategoryIndex - 1)

    local listView = ListView(context)
    local layoutParams = LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT,
        0,
        1.0
    )
    listView.setLayoutParams(layoutParams)

    local currentSources = newsCategories[selectedCategoryIndex].sources
    local function updateChannelsList(catIndex)
        selectedCategoryIndex = catIndex
        saveStorage("selected_category_index", tostring(catIndex))
        currentSources = newsCategories[catIndex].sources or {}

        local displayList = {}
        for i, src in ipairs(currentSources) do
            local fav = isFavorite(src)
            local status = fav and " [★ Favorite]" or ""
            table.insert(displayList, src.name .. status)
        end

        if #displayList == 0 then
            table.insert(displayList, "No channels available")
        end

        local listAdapter = ArrayAdapter(context, android.R.layout.simple_list_item_1, displayList)
        listView.setAdapter(listAdapter)
    end

    updateChannelsList(selectedCategoryIndex)

    spinner.setOnItemSelectedListener(AdapterView.OnItemSelectedListener{
        onItemSelected = function(parent, view, position, id)
            updateChannelsList(position + 1)
        end,
        onNothingSelected = function(parent)
        end
    })

    local backBtn = Button(context)
    backBtn.setText("Go Back")
    backBtn.setTextSize(AppConfig.fontSize)
    backBtn.setOnClickListener(View.OnClickListener{
        onClick = function()
            catDlg.dismiss()
            showMainMenu()
        end
    })

    mainLayout.addView(spinner)
    mainLayout.addView(listView)
    mainLayout.addView(backBtn)

    listView.setOnItemClickListener(AdapterView.OnItemClickListener{
        onItemClick = function(parent, view, position, id)
            if not currentSources or #currentSources == 0 then
                service.speak("No channel selected")
                return
            end
            local selectedSource = currentSources[position + 1]
            if selectedSource then
                catDlg.dismiss()
                showNewsList(selectedSource.name, selectedSource.url)
            end
        end
    })

    listView.setOnItemLongClickListener(AdapterView.OnItemLongClickListener{
        onItemLongClick = function(parent, view, position, id)
            if not currentSources or #currentSources == 0 then return true end
            local selectedSource = currentSources[position + 1]
            if selectedSource then
                toggleFavorite(selectedSource)
                updateChannelsList(selectedCategoryIndex)
            end
            return true
        end
    })

    catDlg.setView(mainLayout)
    catDlg.show()
end

showMainMenu = function()
    local dlg = LuaDialog()
    dlg.setTitle("Latest News Hub")

    local layout = {
        LinearLayout;
        orientation = "vertical";
        padding = "30dp";
        {
            Button;
            text = "Read News";
            textSize = AppConfig.fontSize .. "sp";
            layout_marginBottom = "15dp";
            onClick = function()
                dlg.dismiss()
                showCategoryMenu()
            end;
        };
        {
            Button;
            text = "Settings";
            textSize = AppConfig.fontSize .. "sp";
            layout_marginBottom = "15dp";
            onClick = function()
                dlg.dismiss()
                showSettingsMenu()
            end;
        };
        {
            Button;
            text = "Developer Prince Nabeel";
            textSize = AppConfig.fontSize .. "sp";
            layout_marginBottom = "15dp";
            onClick = function()
                service.speak("Developer Prince Nabeel")
            end;
        };
        {
            Button;
            text = "About";
            textSize = AppConfig.fontSize .. "sp";
            layout_marginBottom = "15dp";
            onClick = function()
                local aboutDlg = LuaDialog()
                aboutDlg.setTitle("About")
                local aboutText = "Welcome to Latest News Hub Extension for Jieshuo Screen Reader.\n\nDeveloper: Prince Nabeel\n\nLatest News Hub is a premier, all-in-one news extension designed to deliver real-time news updates directly to your fingertips. Stay effortlessly informed with curated feeds covering Sports, Business, Health, Science, Cricket, Technology, Regional, Global, and Entertainment news. More exciting categories and sources will be added continuously to ensure a seamless reading experience."
                
                local aboutLayout = {
                    LinearLayout;
                    orientation = "vertical";
                    padding = "20dp";
                    {
                        ScrollView;
                        layout_width = "fill";
                        layout_height = "0dp";
                        layout_weight = 1;
                        {
                            TextView;
                            text = aboutText;
                            textSize = AppConfig.fontSize .. "sp";
                            layout_marginBottom = "15dp";
                        };
                    };
                    {
                        Button;
                        text = "Contact on WhatsApp";
                        textSize = (AppConfig.fontSize - 2) .. "sp";
                        layout_marginBottom = "10dp";
                        onClick = function()
                            openWhatsApp("923234375740")
                        end;
                    };
                    {
                        Button;
                        text = "Go Back";
                        textSize = (AppConfig.fontSize - 2) .. "sp";
                        onClick = function()
                            aboutDlg.dismiss()
                        end;
                    };
                }
                
                aboutDlg.setView(loadlayout(aboutLayout))
                aboutDlg.show()
                if AppConfig.autoSpeakText then
                    service.speak(aboutText)
                end
            end;
        };
        {
            Button;
            text = "Exit";
            textSize = AppConfig.fontSize .. "sp";
            onClick = function()
                dlg.dismiss()
            end;
        };
    }

    dlg.setView(loadlayout(layout))
    dlg.show()
end

showMainMenu()


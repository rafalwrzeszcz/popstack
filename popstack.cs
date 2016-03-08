/**
 * This file is part of the PopStack (C# implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

using System;

using Stream = System.IO.Stream;
using StreamReader = System.IO.StreamReader;

using CompressionMode = System.IO.Compression.CompressionMode;
using GZipStream = System.IO.Compression.GZipStream;

using HttpWebRequest = System.Net.HttpWebRequest;
using HttpWebResponse = System.Net.HttpWebResponse;
using WebRequest = System.Net.WebRequest;

using Match = System.Text.RegularExpressions.Match;
using Regex = System.Text.RegularExpressions.Regex;
using RegexOptions = System.Text.RegularExpressions.RegexOptions;

using HttpUtility = System.Web.HttpUtility;

using JsonTextReader = Newtonsoft.Json.JsonTextReader;

using JArray = Newtonsoft.Json.Linq.JArray;
using JObject = Newtonsoft.Json.Linq.JObject;
using JToken = Newtonsoft.Json.Linq.JToken;

/* TODO
 * build tool
 * dependency management
 * code style
 * static code analysis
 * unit tests
 * auto documentation
 * exception handling
 * use more language features (like overloaded operators, property accessors)
 * logs
 * optimize (try to keep some parts of repetitive executions as instanced objects)
 * "proper" HTTP client setup (headers, gzip as a middleware)
 */

namespace PopStack
{
    class PopStack
    {
        private static readonly Regex Snippet = new Regex("<pre><code>(.*?)</code></pre>", RegexOptions.Singleline);

        public static string BuildRequestUrl(string call)
        {
            return "http://api.stackexchange.com/2.2/" + call + "&site=stackoverflow";
        }

        public static Stream MakeRequest(string call)
        {
            HttpWebRequest request = WebRequest.Create(PopStack.BuildRequestUrl(call)) as HttpWebRequest;
            HttpWebResponse response = request.GetResponse() as HttpWebResponse;
            return new GZipStream(response.GetResponseStream(), CompressionMode.Decompress);
        }

        public static JObject ParseResponse(Stream body)
        {
            return JObject.Load(new JsonTextReader(new StreamReader(body)));
        }

        public static string ExtractSnippet(string content)
        {
            if (PopStack.Snippet.IsMatch(content)) {
                Match match = PopStack.Snippet.Match(content);
                String snippet = match.Groups[1].Value.Trim();
                return HttpUtility.HtmlDecode(snippet);
            }

            return "";
        }

        public static void Main()
        {
            JArray items = PopStack.ParseResponse(
                PopStack.MakeRequest("similar?order=desc&sort=relevance&title=" + "Hibernate manytomany")
            ).Value<JArray>("items");
            JToken buffer;
            foreach (JToken token in items) {
                JObject item = token as JObject;
                if (item.TryGetValue("accepted_answer_id", out buffer)) {
                    String answer = PopStack.ParseResponse(
                        PopStack.MakeRequest("answers/" + buffer.ToString() + "?filter=withbody")
                    ).Value<JArray>("items").Value<JObject>(0).GetValue("body").ToString();

                    Console.WriteLine(PopStack.ExtractSnippet(answer));

                    //TODO: first make sure there was a snippet extracted
                    break;
                }
                //TODO; process more pages maybe?
            }
        }
    }
}

/**
 * This file is part of the PopStack (C# implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

using System;
using System.IO;
using System.IO.Compression;
using System.Net;

using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace PopStack
{
    class PopStack
    {
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

        public static void Main()
        {
            JArray items = PopStack.ParseResponse(
                PopStack.MakeRequest("similar?order=desc&sort=relevance&title=" + "Hibernate manytomany")
            ).Value<JArray>("items");
            JToken buffer;
            foreach (JToken token in items) {
                JObject item = token as JObject;
                if( item.TryGetValue("accepted_answer_id", out buffer) ) {
                    //TODO
                }
            }
        }
    }
}

<%@ WebHandler Language="C#" Class="ColorData" %>

using System;
using System.Web;
using System.Collections.Generic;
using System.Linq;
using System.Drawing;
using System.Reflection;
using Newtonsoft.Json;

public class ColorData : IHttpHandler
{
    private static List<string> ColorNamesList = new List<string>();
    
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string keyword = context.Request["k"] ?? "";

        if (ColorNamesList.Count <= 0)
            GetColorNames();

        var Get10Color = ColorNamesList.Take(10).ToList();
        if (keyword != "")
        {
            Get10Color = ColorNamesList.Where(s=> s.Contains(keyword)).Take(10).ToList();
        }
        
        string str_json = JsonConvert.SerializeObject(Get10Color);
        context.Response.Write(str_json);
    }

    /// <summary>
    /// 取得系統顏色的所有名稱，並填入 ColorNamesList 靜態變數中
    /// </summary>
    private void GetColorNames()
    {
        foreach (var colorValue in Enum.GetValues(typeof(KnownColor)))
        {
            ColorNamesList.Add(Color.FromKnownColor((KnownColor)colorValue).Name);
        }
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}
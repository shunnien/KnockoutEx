<%@ WebHandler Language="C#" Class="EmpData" %>

using System;
using System.Web;
using System.Linq;
using System.Collections.Generic;
using System.Reflection;
using System.Web.Script.Serialization;

public class EmpData : IHttpHandler
{
    public class User
    {
        public string EmpNo { get; set; }
        public string EmpName { get; set; }
    }
    private static Dictionary<string, User> users = null;
    private static Dictionary<string, User> Users
    {
        get
        {
            int i = 0;
            if (users == null)
            {
                users = typeof(System.Drawing.Color)
                .GetProperties(BindingFlags.Static | BindingFlags.Public)
                .ToDictionary(
                    o => (++i).ToString(),
                    o => new User()
                    {
                        EmpNo = i.ToString("0000"),
                        EmpName = o.Name
                    }
                );
            }
            return users;
        }
    }

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string empNo = (context.Request["u"] ?? string.Empty).TrimStart('0');
        User u = Users.ContainsKey(empNo) ? Users[empNo] : new User();
        JavaScriptSerializer jss = new JavaScriptSerializer();
        context.Response.Write(jss.Serialize(u));
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}
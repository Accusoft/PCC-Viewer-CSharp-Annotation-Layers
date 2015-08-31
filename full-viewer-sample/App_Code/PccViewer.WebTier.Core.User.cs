using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for User
/// </summary>
namespace PccViewer.WebTier.Core
{
    public static class User
    {
        static User() { name = "user1"; }

        public static String name
        {
            get; private set;
        }

        public static void setName (string newName)
        {
            name = newName;
        }


    } 
}
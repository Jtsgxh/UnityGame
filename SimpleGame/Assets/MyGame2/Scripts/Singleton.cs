using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Singleton<T> where T : class, new()
{
    // The static instance of the singleton class
    private static T _instance;

    // The public property to access the instance
    public static T Instance
    {
        get
        {
            // If the instance is null, create a new object using the default constructor
            if (_instance == null)
            {
                _instance = new T();
            }

            // Return the instance
            return _instance;
        }
    }

    // The protected constructor that prevents creating new instances from outside
    protected Singleton()
    {

    }
}

public class ManagerInstance
{
    private static ManagerInstance _instance;

    public static ManagerInstance Instance
    {
        get
        {
            if (_instance == null)
            {
                _instance = new ManagerInstance();
            }

            return _instance;
        }
    }
}
 

using UnityEngine;

public  class GameTool
{
    public static Transform FindRecursively(Transform parent, string name)
    {
        // 如果父物体的名字和要查找的名字相同，就返回父物体
        if (parent.name == name)
        {
            return parent;
        }
        // 否则，遍历父物体的所有子物体
        for (int i = 0; i < parent.childCount; i++)
        {
            // 获取当前子物体
            Transform child = parent.GetChild(i);
            // 递归调用自己，传入当前子物体和要查找的名字
            Transform result = FindRecursively(child, name);
            // 如果找到了结果，就返回结果
            if (result != null)
            {
                return result;
            }
        }
        // 如果遍历完所有子物体都没有找到结果，就返回空
        return null;
    } 
    
    public static T FindComponentRecursively<T>(Transform parent) where T:Component
    {
        // 如果父物体的名字和要查找的名字相同，就返回父物体
        if (parent.GetComponent<T>()!=null)
        {
            return parent.GetComponent<T>();
        }
        // 否则，遍历父物体的所有子物体
        for (int i = 0; i < parent.childCount; i++)
        {
            // 获取当前子物体
            Transform child = parent.GetChild(i);
            // 递归调用自己，传入当前子物体和要查找的名字
            var result = FindComponentRecursively<T>(child);
            // 如果找到了结果，就返回结果
            if (result != null)
            {
                return result;
            }
        }
        // 如果遍历完所有子物体都没有找到结果，就返回空
        return null;
    } 
}
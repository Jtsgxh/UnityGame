using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

public class WeaponInfo 
{
    public GunData gunData;
    public double lastReloadTime;
    public double lastShootTime;
    public int currentAmmo;
    public WeaponManager BagData;

    public WeaponInfo(GunData gunData,WeaponManager data)
    {
        this.BagData = data;
    }
    public void Init()
    {
        
    }
    public virtual void Shoot( Vector3 shootDirection)
    {
        //这里应该load子弹 然后改变子弹的速度射出去 
        //暂时先打个射线看下方向好了
        GameObject.Instantiate(GameObject.CreatePrimitive(PrimitiveType.Sphere),BagData.transform.position,Quaternion.identity);
       
    }
    public virtual void Reload()
    {
        
    }
    

}

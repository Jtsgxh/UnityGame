using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WeaponInfo 
{
    public GunData gunData;
    public double lastReloadTime;
    public double lastShootTime;
    public int currentAmmo;
    public void Init()
    {
        
    }
    public virtual void Shoot( Vector3 shootDirection)
    {
        //这里应该load子弹 然后改变子弹的速度射出去 
        //暂时先打个射线看下方向好了
        
       
    }
    public virtual void Reload()
    {
        
    }
    

}

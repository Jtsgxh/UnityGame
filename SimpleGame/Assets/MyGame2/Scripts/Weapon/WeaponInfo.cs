using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

public class WeaponInfo:MonoBehaviour
{
    public GunData gunData;
    public double lastReloadTime;
    public double lastShootTime;
    public int currentAmmo;
    public Transform weaponShootPoint;
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
        GameObject gameObject = GameObject.CreatePrimitive(PrimitiveType.Sphere);
        gameObject.transform.position = weaponShootPoint.position;
        gameObject.transform.localScale=Vector3.one*0.1f;
        var rigidbody = gameObject.AddComponent<Rigidbody>();
        rigidbody.velocity = shootDirection * 50;
    }
    public virtual void Reload()
    {
        
    }
    

}

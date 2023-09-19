/*
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class Weapon : MonoBehaviour
{
    [HideInInspector] public enum WeaponType
    {
        NoAction,
        None,
        Rifle,
        Pistol,
        Knife
    };
    public int bulletMaxCount;
    public int nowBulletCount;
    public int bulletInMagazine;
    public int magazineMaxCount;
    
    //may be it should have a magazine object
    public float bulletSpeed;
    public float shootInterval;
    public Transform aimPoint;
    public float reloadAnimationTime;
    public Transform aimTarget;
    public WeaponType weaponType;
    public int weaponLayer;
    public string fireAnimationName;
    public string reloadAnimationName;
    [HideInInspector]public enum WeaponMode
    {
        semi,
        auto,
    }
    public WeaponMode weaponMode;
    public WeaponManager WeaponManager;
    private void Start()
    {
        WeaponManager=ManagerList.Instance.weaponManager;
    }

    public virtual void Reload()
    {
        StartCoroutine(ReLoading());
    }
    
    IEnumerator ReLoading()
    {   ManagerList.Instance.animatorController.Play("ReLoad",weaponLayer,0.0f);
        WeaponManager.isReloading = true;
        yield return new WaitForSeconds(reloadAnimationTime);
        WeaponManager.isReloading = false;
        Debug.Log("Reload");
        var needBulletNum = magazineMaxCount - nowBulletCount;
        if (needBulletNum > bulletInMagazine)
        {
            nowBulletCount += bulletInMagazine;
            bulletInMagazine = 0;
        }
        else
        {
            nowBulletCount += needBulletNum;
            bulletInMagazine -= needBulletNum;
        }
    }
    
    public virtual void Shoot(Vector3 shootPoint,Vector3 shootTarget)
    {
        if (WeaponManager.isReloading)
        {
            return;
        }
        //Debug.Log("Shoot");
        nowBulletCount -= 1;
        ManagerList.Instance.animatorController.Play("Shoot",weaponLayer,0.0f);
        //从shootPoint向shootTarget射一个球
        var bullet = GameObject.CreatePrimitive(PrimitiveType.Sphere);
        bullet.transform.position = shootPoint;
        bullet.transform.localScale = new Vector3(0.1f,0.1f,0.1f);
        bullet.AddComponent<Rigidbody>();
        bullet.GetComponent<Rigidbody>().AddForce((shootTarget-shootPoint).normalized*bulletSpeed,ForceMode.Impulse);
    }

    public virtual void BeforeChange()
    {
        
    }

    public virtual void AfterChange()
    {
        
    }

    public virtual void BeforeChange2Other()
    {
        
    }
    
}
*/

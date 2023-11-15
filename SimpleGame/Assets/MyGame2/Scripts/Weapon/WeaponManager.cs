using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WeaponManager : MonoBehaviour
{
    public WeaponBagData BagData;
    public WeaponManageMethod weaponManageMethod;
    private InputDataNew InputDataNew;
    private Transform mainCamera;
    [SerializeField]
    private GunData GunData;
    //这里临时先通过这样获取相机和添加基础武器信息
    public void Awake()
    {
        BagData = GetComponent<WeaponBagData>();
        weaponManageMethod = new WeaponManageMethod01(this);
        InputDataNew = gameObject.GetComponent<InputDataNew>();
        mainCamera = Camera.main.transform;
    
    }

    private void Start()
    {
        /*var weaponInfo = weaponManageMethod.BuildWeapon(GunData);
        InitWeapon(weaponInfo);*/
        var weaponInfo = weaponManageMethod.LoadWeapon("WaterGun");
        InitWeapon(weaponInfo);
    }


    private void Update()
    {
        if (InputDataNew.shoot)
        {
            weaponManageMethod.Shoot(mainCamera.forward);
        }
    }

    public WeaponInfo NowWeaponInfo
    {
        get
        {
            return BagData.weaponInfos[BagData.nowWeaponIndex];
        }
    }

    public void InitWeapon(WeaponInfo info)
    {
        weaponManageMethod.AddWeapon(info);
        Vector3 pos = info.transform.position;
        info.transform.SetParent(FindRecursively(this.transform,info.gunData.hangPointName));
        info.transform.localPosition = pos;
        // info.transform.SetParent(this.gameObject.transform.Find(info.gunData.hangPointName));
    }
    
    Transform FindRecursively(Transform parent, string name)
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

   
}

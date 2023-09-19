/*
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using RootMotion.FinalIK;
using UnityEngine;

public class WeaponManager : MonoBehaviour
{
    // Start is called before the first frame update
    public Weapon[] weaponsInHand;
    private const int weaponCount = 4;
    public int weaponIndex;
    public Transform weaponPoint;
   // public Quaternion weaponRotation;
    public float sinceLastShootTime;
    public float lastReloadTime;
    public bool isReloading;
    //these below are for aimIK
    public Transform aimTarget;
    public AimIK aimIk;
    public bool isLastPressShoot;
    public bool nowPressShoot;
    public bool isPressDown;
    public bool isPress;
    public int _RifleHash;
    public Weapon GetNowWeapon()
    {
        return weaponsInHand[weaponIndex];
    }
    public Weapon.WeaponMode GetNowWeaponMode()
    {
        return weaponsInHand[weaponIndex].weaponMode;
    }

    private void Update()
    {
        aimIk.solver.target = aimTarget;
    }


    public void Shoot(Vector3 shootPoint,Vector3 shootTarget,float deltaTime)
    {
        sinceLastShootTime += deltaTime;
        var nowWeapon = GetNowWeapon();
        if (nowWeapon.nowBulletCount<=0)
        {
            return;
        }
        if(sinceLastShootTime<nowWeapon.shootInterval) return;
        if (isPress && nowWeapon.weaponMode == Weapon.WeaponMode.auto)
        {
            nowWeapon.Shoot(shootPoint,shootTarget);
            sinceLastShootTime = 0;
        }
        else if (isPressDown && nowWeapon.weaponMode == Weapon.WeaponMode.semi)
        {
            nowWeapon.Shoot(shootPoint,shootTarget);
            sinceLastShootTime = 0;
        }
        else
        {
            return;
        }
    }

    public void Reload()
    {
        var nowWeapon = GetNowWeapon();
        if (nowWeapon.bulletMaxCount > 0&&nowWeapon.nowBulletCount<nowWeapon.magazineMaxCount)
        {
            nowWeapon.Reload();
        }
    }

    public void SetShoot(bool isShoot,float deltaTime)
    {
        if (isShoot)
        {
            isLastPressShoot = nowPressShoot;
            nowPressShoot = true;
            isPressDown = !isLastPressShoot && nowPressShoot;
            isPress = isLastPressShoot && nowPressShoot;
        }
        else
        {
            isLastPressShoot = nowPressShoot;
            nowPressShoot = false;
            isPressDown = false;
            isPress = false;
        }
        Shoot(GetNowWeapon().aimPoint.position,aimTarget.position,deltaTime);
    }

    public void AddWeapon(Weapon weapon)
    {
        weaponsInHand=weaponsInHand.Append(weapon).ToArray();
    }

    public void LoadWeaponFromDist(string[] weaponList)
    {
        foreach (var weaponName in weaponList)
        {
            var weapon = Resources.Load<Weapon>("Weapon/"+weaponName);
            weapon = Instantiate(weapon,weaponPoint);
           // weaponsInHand[weaponIndex].transform.SetParent(weaponPoint);
            weapon.gameObject.SetActive(false);
            AddWeapon(weapon);
        }
    }
    public void ManagerStart()
    {
        ManagerList.Instance.weaponManager = this;
    // new Weapon[weaponCount];
        aimIk = GetComponent<AimIK>();
        _RifleHash = Animator.StringToHash("Rifle");
        //CREATE A EMPTY GAMEOBJECT
        aimTarget = new GameObject("AimTarget").transform;
        LoadWeaponFromDist(new string[] { "Assault_Rifle_03" });
    }
    public virtual void ChangeWeapon(int index)
    {
        var nowWeapon = GetNowWeapon();
        nowWeapon.gameObject.SetActive(false);
        GetNowWeapon().BeforeChange2Other();
        weaponsInHand[weaponIndex] = weaponsInHand[index];
        weaponsInHand[weaponIndex].gameObject.SetActive(true);
        GetNowWeapon().BeforeChange();
        GetNowWeapon().AfterChange();
    }
}
*/

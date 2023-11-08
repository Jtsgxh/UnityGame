using UnityEngine;
public abstract class WeaponManageMethod
{
    public WeaponManager weaponBagManager;
    
    public WeaponManageMethod(WeaponManager mgr)
    {
        this.weaponBagManager = mgr;
    }
    
    public abstract void Shoot(Vector3 shootDirection);

    public abstract void Reload();

    public abstract void BeforeShoot();
    
    public abstract void AfterShoot();
    
    public abstract void BeforeReload();
    
    public abstract void AfterReload();

    public virtual void OnChangeWeapon()
    {
        
    }

    public virtual void ChangeWeapon(int index)
    {
        weaponBagManager.BagData.nowWeaponIndex = index;
        OnChangeWeapon();
    }
    
    public virtual void AddWeapon(WeaponInfo weaponInfo)
    {
        weaponBagManager.BagData.weaponInfos.Add(weaponInfo);
    }

    public virtual WeaponInfo BuildWeapon(GunData data)
    {
        return new WeaponInfo();
    }
    
}
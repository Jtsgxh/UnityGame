using UnityEngine;

public class WeaponManageMethod01:WeaponManageMethod
{
    public WeaponManageMethod01(WeaponManager mgr) : base(mgr)
    {
        
    }

    public override void Shoot(Vector3 shootDirection)
    {
        BeforeShoot();
        //
        weaponBagManager.NowWeaponInfo.Shoot(shootDirection);
        AfterShoot();
    }

    public override void Reload()
    {
        BeforeReload();
        //
        AfterReload();
    }

    public override void BeforeShoot()
    {
       
    }

    public override void AfterShoot()
    {
       
    }

    public override void BeforeReload()
    {
        
    }

    public override void AfterReload()
    {
        
    }
    
    
}

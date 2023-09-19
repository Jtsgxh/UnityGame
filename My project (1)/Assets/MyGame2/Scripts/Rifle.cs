/*
using Unity.VisualScripting;
using UnityEngine;

public class Rifle:Weapon
{
    
    public override void BeforeChange()
    {
        //播放切换动画
        ManagerList.Instance.weaponManager.aimIk.enabled = true;
        ManagerList.Instance.animatorController.Play("RifleShoot", 1);
        ManagerList.Instance.animatorController.SetBool(ManagerList.Instance.weaponManager._RifleHash,true);
        ManagerList.Instance.animatorController.SetLayerWeight(weaponLayer,1);
        
    }

    public override void AfterChange()
    {
        
    }

    public override void Shoot(Vector3 shootPoint, Vector3 shootTarget)
    {
        Debug.Log("Rifle Shoot");
        base.Shoot(shootPoint, shootTarget);
    }

    public override void BeforeChange2Other()
    {
        ManagerList.Instance.animatorController.SetLayerWeight(weaponLayer,0);
        ManagerList.Instance.animatorController.SetBool(ManagerList.Instance.weaponManager._RifleHash,false);
        ManagerList.Instance.weaponManager.aimIk.enabled = false;
    }
}
*/

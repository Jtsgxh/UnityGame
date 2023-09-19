using System;
using UnityEngine;

public abstract class WeaponNew:MonoBehaviour{
    [HideInInspector] public enum WeaponType
    {
        NoAction,
        None,
        Rifle,
        Pistol,
        Knife
    };
    
    [HideInInspector]public enum WeaponMode
    {
        semi,
        auto,
    }
    public WeaponMode weaponMode;

    public Transform shootPoint;
    public WeaponType weaponType;
    public int bulletInMagazine;
    public int magazineMaxCount;
    public float bulletSpeed;
    public float shootInterval;
}

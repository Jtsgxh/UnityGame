using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[CreateAssetMenu(fileName = "GunData", menuName = "ScriptableObjects/SpawnGunData", order = 1)]
public class GunData : ScriptableObject
{
    public float fireRate;
    public float damage;
    public float range;
    public float impactForce;
    public float maxAmmo;
    public float reloadTime;
    public string weaponPrefabName;
    public string bulletPrefabName;
    public string hangPointName;
}

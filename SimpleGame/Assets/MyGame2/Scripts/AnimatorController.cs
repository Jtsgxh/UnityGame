using System.Collections;
using System.Collections.Generic;
using UnityEngine;
//增加animator组件
[RequireComponent(typeof(Animator))]
public class AnimatorController : MonoBehaviour
{
    // Start is called before the first frame update
    public Animator animator;
    void Start()
    {
        animator=GetComponent<Animator>();
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}

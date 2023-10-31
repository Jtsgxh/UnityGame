using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class StateBase
{
    public abstract void BeforeEnter();

    public abstract void AfterExit();
}

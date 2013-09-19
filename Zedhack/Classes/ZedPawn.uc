class ZedPawn extends UDKPawn;

    simulated function name GetDefaultCameraMode( PlayerController RequestedBy )
{
    if ( RequestedBy != None && RequestedBy.PlayerCamera != None && RequestedBy.PlayerCamera.CameraStyle == 'Fixed' )
        return 'Fixed';

        return 'Isometric';
}
    
    //only update pawn rotation while moving
simulated function FaceRotation(rotator NewRotation, float DeltaTime)
{
    // Do not update Pawn's rotation if no accel
    if (Normal(Acceleration)!=vect(0,0,0))
    {
        if ( Physics == PHYS_Ladder )
        {
            NewRotation = OnLadder.Walldir;
        }
        else if ( (Physics == PHYS_Walking) || (Physics == PHYS_Falling) )
        {
            NewRotation = rotator((Location + Normal(Acceleration))-Location);
            NewRotation.Pitch = 0;
        }
        
        SetRotation(NewRotation);
    }
    
}

defaultproperties
{
    Components.Remove(Sprite)

    Begin Object Class=DynamicLightEnvironmentComponent Name=ZedLightEnvironment
        MinTimeBetweenFullUpdates=0.2
        AmbientGlow=(R=.01,G=.01,B=.01,A=1)
        AmbientShadowColor=(R=0.15,G=0.15,B=0.15)
        LightShadowMode=LightShadow_ModulateBetter
        ShadowFilterQuality=SFQ_High
        bSynthesizeSHLight=TRUE
    End Object
    Components.Add(ZedLightEnvironment)

    Begin Object Class=SkeletalMeshComponent Name=InitialSkeletalMesh
        CastShadow=true
        bCastDynamicShadow=true
        bOwnerNoSee=false
        LightEnvironment=ZedLightEnvironment;
        BlockRigidBody=true;
        CollideActors=true;
        BlockZeroExtent=true;
        PhysicsAsset=PhysicsAsset'CH_AnimCorrupt.Mesh.SK_CH_Corrupt_Male_Physics'
        AnimSets(0)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_AimOffset'
        AnimSets(1)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_BaseMale'
        AnimTreeTemplate=AnimTree'CH_AnimHuman_Tree.AT_CH_Human'
        SkeletalMesh=SkeletalMesh'CH_LIAM_Cathode.Mesh.SK_CH_LIAM_Cathode'
    End Object

    Mesh=InitialSkeletalMesh;
    Components.Add(InitialSkeletalMesh);
    
    GroundSpeed=500.0    
    
    Begin Object Name=CollisionCylinder
    CollisionRadius=30
    CollisionHeight=49
    End Object
    CylinderComponent=CollisionCylinder
}
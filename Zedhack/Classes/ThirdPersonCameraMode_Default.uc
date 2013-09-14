class ThirdPersonCameraMode_Default extends GameThirdPersonCameraMode_Default;

var float FOV;

function float GetDesiredFOV( Pawn ViewedPawn )
{
    return FOV;
}

defaultproperties
{
    FOV=90.f;
    TargetRelativeCameraOriginOffset=(x=-0,y=-0,z=0)
    bLockedToViewTarget=TRUE
    bFollowTarget=TRUE
    bInterpLocation=TRUE
    bInterpRotation=TRUE
    bSkipCameraCollision=TRUE
    BlendTime=0.75
}
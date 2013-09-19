class ZedPlayerController extends UDKPlayerController
    config(Game);

    var float CamZoom;
    var float CamMinDistance, CamMaxDistance;
    
//Update player rotation when walking
state PlayerWalking
{
ignores SeePlayer, HearNoise, Bump;


   function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
   {
      local Vector tempAccel;
        local Rotator CameraRotationYawOnly;
        

      if( Pawn == None )
      {
         return;
      }

      if (Role == ROLE_Authority)
      {
         // Update ViewPitch for remote clients
         Pawn.SetRemoteViewPitch( Rotation.Pitch );
      }

      tempAccel.Y =  PlayerInput.aStrafe * DeltaTime * 100 * PlayerInput.MoveForwardSpeed;
      tempAccel.X = PlayerInput.aForward * DeltaTime * 100 * PlayerInput.MoveForwardSpeed;
      tempAccel.Z = 0; //no vertical movement for now, may be needed by ladders later
      
     //get the controller yaw to transform our movement-accelerations by
    CameraRotationYawOnly.Yaw = Rotation.Yaw; 
    tempAccel = tempAccel>>CameraRotationYawOnly; //transform the input by the camera World orientation so that it's in World frame
    Pawn.Acceleration = tempAccel;
   
    Pawn.FaceRotation(Rotation,DeltaTime); //notify pawn of rotation

    CheckJumpOrDuck();
   }
}

//Controller rotates with turning input
function UpdateRotation( float DeltaTime )
{
local Rotator   DeltaRot, newRotation, ViewRotation;

   ViewRotation = Rotation;
   if (Pawn!=none)
   {
      Pawn.SetDesiredRotation(ViewRotation);
   }

   // Calculate Delta to be applied on ViewRotation
   DeltaRot.Yaw   = PlayerInput.aBaseX;
   DeltaRot.Pitch   = PlayerInput.aLookUp;

   ProcessViewRotation( DeltaTime, ViewRotation, DeltaRot );
   SetRotation(ViewRotation);

   NewRotation = ViewRotation;
   NewRotation.Roll = Rotation.Roll;

   if ( Pawn != None )
      Pawn.FaceRotation(NewRotation, deltatime); //notify pawn of rotation
}   

function PawnDied(Pawn P)
{
    Super.PawnDied(P);
    ClientPawnDied();
}

/**
 * Client-side notification that the pawn has died.
 */
reliable client simulated function ClientPawnDied()
{
    // Unduck if ducking
    bDuck = 0;
}

exec function ZoomIn ()
{
    if (PlayerCamera.FreeCamDistance > CamMinDistance )
    PlayerCamera.FreeCamDistance-=CamZoom;
}

exec function ZoomOut ()
{
    if ( PlayerCamera.FreeCamDistance < CamMaxDistance )
    PlayerCamera.FreeCamDistance+=CamZoom;
}

defaultproperties
{
    CameraClass=class'Zedhack.IsoCam'
    CamZoom = 10
    CamMaxDistance = 550
    CamMinDistance = 250
}
catch { load vtktcl }
if { [catch {set VTK_TCL $env(VTK_TCL)}] != 0} { set VTK_TCL "../../examplesTcl" }
if { [catch {set VTK_DATA $env(VTK_DATA)}] != 0} { set VTK_DATA "../../../vtkdata" }


vtkVideoSource grabber
#grabber SetOutputFormatToRGB  
#grabber SetFrameSize 640 480 1 
#grabber SetOutputWholeExtent 0 319 0 239 0 0 
grabber SetFrameBufferSize 50 
grabber SetNumberOfOutputFrames 50 
grabber Grab  

[grabber GetOutput] UpdateInformation  

vtkImageViewer viewer  
viewer SetInput [grabber GetOutput]   
#[viewer GetImageWindow] DoubleBufferOn  
viewer SetColorWindow 255 
viewer SetColorLevel 127.5 
viewer SetZSlice 0 

viewer Render  

proc animate {} {
    global grabber viewer

    if { [grabber GetPlaying] == 1 } {
        viewer Render  
        after 1 animate
    }
} 

proc Play {} {
    global grabber

    if { [grabber GetPlaying] != 1 } { 
	grabber Play  
        animate
    }
}  

proc Stop {} {
    global grabber

    grabber Stop
}  

proc Grab {} {
    global grabber viewer

    grabber Grab  
    viewer Render
}  

frame .controls 
button .controls.grab -text "Grab" -command Grab 
pack .controls.grab -side left 
button .controls.stop -text "Stop" -command Stop 
pack .controls.stop -side left 
button .controls.play -text "Play" -command Play 
pack .controls.play -side left 
pack .controls -side top  

proc SetFrameRate { r } {
    global grabber

    grabber SetFrameRate $r
}  

frame .rate 
label .rate.label -text "Frames/s" 
scale .rate.scale -from 0.0 -to 60.0 -orient horizontal -command SetFrameRate
.rate.scale set [grabber GetFrameRate]   

pack .rate.label -side left 
pack .rate.scale -side left 
pack .rate -side top 

proc SetFrame { f } {
    global viewer

    viewer SetZSlice $f  
    viewer Render
}

frame .viewframe
label .viewframe.label -text "Frame #" 
scale .viewframe.scale -from 0 -to 49 -orient horizontal -command SetFrame

pack .viewframe.label -side left 
pack .viewframe.scale -side left 
pack .viewframe -side top 

frame .ex  
button .ex.button -text "Exit" -command exit 

pack .ex.button -side left 
pack .ex -side top 










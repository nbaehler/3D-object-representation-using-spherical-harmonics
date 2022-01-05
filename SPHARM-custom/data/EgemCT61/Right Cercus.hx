# Amira Script
remove -all
remove glow.col Egem_CT_6_1.bmp Egem_CT_6_1-labels Egem_CT_6_1-labels.Resampled Egem_CT_6_1-labels.surf OrthoSlice Resample SurfaceGen SurfaceView

# Create viewers
viewer setVertical 0

viewer 0 setBackgroundMode 1
viewer 0 setBackgroundColor 0.06 0.13 0.24
viewer 0 setBackgroundColor2 0.72 0.72 0.78
viewer 0 setTransparencyType 5
viewer 0 setAutoRedraw 0
viewer 0 setCameraType 1
viewer 0 show
mainWindow show

set hideNewModules 1
[ load ${AMIRA_ROOT}/data/colormaps/glow.col ] setLabel glow.col
glow.col setIconPosition 0 0
glow.col setNoRemoveAll 1
glow.col fire
{glow.col} setMinMax 0 255
glow.col flags setValue 1
glow.col shift setMinMax -1 1
glow.col shift setButtons 0
glow.col shift setIncrement 0.133333
glow.col shift setValue 0
glow.col shift setSubMinMax -1 1
glow.col scale setMinMax 0 1
glow.col scale setButtons 0
glow.col scale setIncrement 0.1
glow.col scale setValue 1
glow.col scale setSubMinMax 0 1
glow.col fire
glow.col setViewerMask 65535

set hideNewModules 0
[ load -bmp +box 0 1323.19 0 1363.67 0 741.29 +mode 1 ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0199.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0200.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0201.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0202.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0203.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0204.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0205.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0206.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0207.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0208.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0209.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0210.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0211.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0212.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0213.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0214.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0215.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0216.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0217.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0218.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0219.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0220.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0221.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0222.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0223.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0224.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0225.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0226.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0227.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0228.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0229.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0230.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0231.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0232.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0233.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0234.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0235.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0236.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0237.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0238.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0239.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0240.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0241.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0242.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0243.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0244.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0245.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0246.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0247.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0248.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0249.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0250.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0251.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0252.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0253.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0254.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0255.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0256.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0257.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0258.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0259.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0260.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0261.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0262.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0263.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0264.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0265.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0266.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0267.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0268.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0269.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0270.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0271.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0272.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0273.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0274.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0275.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0276.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0277.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0278.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0279.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0280.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0281.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0282.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0283.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0284.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0285.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0286.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0287.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0288.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0289.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0290.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0291.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0292.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0293.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0294.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0295.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0296.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0297.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0298.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0299.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0300.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0301.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0302.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0303.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0304.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0305.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0306.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0307.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0308.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0309.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0310.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0311.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0312.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0313.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0314.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0315.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0316.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0317.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0318.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0319.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0320.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0321.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0322.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0323.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0324.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0325.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0326.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0327.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0328.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0329.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0330.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0331.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0332.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0333.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0334.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0335.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0336.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0337.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0338.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0339.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0340.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0341.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0342.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0343.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0344.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0345.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0346.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0347.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0348.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0349.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0350.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0351.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0352.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0353.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0354.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0355.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0356.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0357.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0358.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0359.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0360.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0361.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0362.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0363.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0364.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0365.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0366.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0367.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0368.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0369.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0370.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0371.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0372.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0373.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0374.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0375.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0376.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0377.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0378.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0379.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0380.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0381.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0382.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0383.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0384.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0385.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0386.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0387.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0388.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0389.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0390.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0391.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0392.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0393.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0394.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0395.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0396.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0397.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0398.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0399.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0400.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0401.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0402.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0403.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0404.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0405.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0406.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0407.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0408.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0409.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0410.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0411.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0412.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0413.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0414.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0415.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0416.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0417.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0418.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0419.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0420.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0421.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0422.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0423.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0424.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0425.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0426.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0427.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0428.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0429.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0430.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0431.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0432.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0433.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0434.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0435.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0436.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0437.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0438.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0439.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0440.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0441.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0442.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0443.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0444.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0445.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0446.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0447.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0448.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0449.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0450.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0451.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0452.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0453.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0454.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0455.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0456.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0457.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0458.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0459.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0460.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0461.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0462.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0463.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0464.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0465.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0466.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0467.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0468.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0469.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0470.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0471.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0472.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0473.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0474.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0475.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0476.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0477.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0478.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0479.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0480.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0481.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0482.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0483.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0484.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0485.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0486.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0487.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0488.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0489.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0490.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0491.bmp ${SCRIPTDIR}/../reconstruction/egem_ct_6_1__rec0492.bmp ] setLabel Egem_CT_6_1.bmp
Egem_CT_6_1.bmp setIconPosition 20 10
Egem_CT_6_1.bmp fire
Egem_CT_6_1.bmp fire
Egem_CT_6_1.bmp setViewerMask 65535

set hideNewModules 0
[ load "${SCRIPTDIR}/Right Cercus-files/Egem_CT_6_1-labels" ] setLabel Egem_CT_6_1-labels
Egem_CT_6_1-labels setIconPosition 20 30
Egem_CT_6_1-labels ImageData connect Egem_CT_6_1.bmp
Egem_CT_6_1-labels fire
Egem_CT_6_1-labels primary setValue 0 0
Egem_CT_6_1-labels fire
Egem_CT_6_1-labels setViewerMask 65535

set hideNewModules 0
create HxOrthoSlice {OrthoSlice}
OrthoSlice setIconPosition 380 10
OrthoSlice data connect Egem_CT_6_1.bmp
{OrthoSlice} fire
OrthoSlice sliceOrientation setValue 0
{OrthoSlice} fire
OrthoSlice options setValue 0 1
OrthoSlice options setValue 1 0
OrthoSlice options setValue 2 0
OrthoSlice mappingType setValue 0 0
OrthoSlice linearRange setMinMax 0 -1.00000001384843e+024 1.00000001384843e+024
OrthoSlice linearRange setValue 0 0
OrthoSlice linearRange setMinMax 1 -1.00000001384843e+024 1.00000001384843e+024
OrthoSlice linearRange setValue 1 255
OrthoSlice contrastLimit setMinMax 0 -1.00000001384843e+024 1.00000001384843e+024
OrthoSlice contrastLimit setValue 0 7
OrthoSlice colormap setDefaultColor 1 0.8 0.5
OrthoSlice colormap setDefaultAlpha 1.000000
OrthoSlice colormap connect glow.col
OrthoSlice sliceNumber setMinMax 0 293
OrthoSlice sliceNumber setButtons 1
OrthoSlice sliceNumber setIncrement 1
OrthoSlice sliceNumber setValue 128
OrthoSlice sliceNumber setSubMinMax 0 293
OrthoSlice transparency setValue 0
OrthoSlice setFrameWidth 0
OrthoSlice setFrameColor 1 0.5 0
OrthoSlice frame 1
OrthoSlice fire

OrthoSlice fire
OrthoSlice setViewerMask 65534

set hideNewModules 0
create HxResample {Resample}
Resample setIconPosition 160 60
Resample data connect Egem_CT_6_1-labels
{Resample} fire
Resample filter setValue 0 4
Resample mode setValue 0
Resample resolution setMinMax 0 1 10000
Resample resolution setValue 0 524
Resample resolution setMinMax 1 1 10000
Resample resolution setValue 1 540
Resample resolution setMinMax 2 1 10000
Resample resolution setValue 2 294
Resample voxelSize setMinMax 0 -1.00000001384843e+024 1.00000001384843e+024
Resample voxelSize setValue 0 2.52999973297119
Resample voxelSize setMinMax 1 -1.00000001384843e+024 1.00000001384843e+024
Resample voxelSize setValue 1 2.53000020980835
Resample voxelSize setMinMax 2 -1.00000001384843e+024 1.00000001384843e+024
Resample voxelSize setValue 2 2.52999973297119
Resample average setMinMax 0 1 32
Resample average setValue 0 2
Resample average setMinMax 1 1 32
Resample average setValue 1 2
Resample average setMinMax 2 1 32
Resample average setValue 2 2
Resample fire
Resample setViewerMask 65535

set hideNewModules 0
[ {Resample} create
 ] setLabel {Egem_CT_6_1-labels.Resampled}
Egem_CT_6_1-labels.Resampled setIconPosition 20 90
Egem_CT_6_1-labels.Resampled master connect Resample
Egem_CT_6_1-labels.Resampled fire
Egem_CT_6_1-labels.Resampled primary setValue 0 0
Egem_CT_6_1-labels.Resampled fire
Egem_CT_6_1-labels.Resampled setViewerMask 65535

set hideNewModules 0
create HxGMC {SurfaceGen}
SurfaceGen setIconPosition 160 120
SurfaceGen data connect Egem_CT_6_1-labels.Resampled
SurfaceGen fire
SurfaceGen smoothing setValue 0 1
SurfaceGen options setValue 0 1
SurfaceGen options setValue 1 0
SurfaceGen border setValue 0 1
SurfaceGen border setValue 1 0
SurfaceGen minEdgeLength setMinMax 0 0 0.800000011920929
SurfaceGen minEdgeLength setValue 0 0
SurfaceGen materialList setValue 0 0
SurfaceGen fire
SurfaceGen setViewerMask 65535
SurfaceGen select

set hideNewModules 0
[ {SurfaceGen} create {Egem_CT_6_1-labels.surf}
 ] setLabel {Egem_CT_6_1-labels.surf}
Egem_CT_6_1-labels.surf setIconPosition 20 150
Egem_CT_6_1-labels.surf master connect SurfaceGen
Egem_CT_6_1-labels.surf fire
Egem_CT_6_1-labels.surf LevelOfDetail setMinMax -1 -1
Egem_CT_6_1-labels.surf LevelOfDetail setButtons 1
Egem_CT_6_1-labels.surf LevelOfDetail setIncrement 1
Egem_CT_6_1-labels.surf LevelOfDetail setValue -1
Egem_CT_6_1-labels.surf LevelOfDetail setSubMinMax -1 -1
Egem_CT_6_1-labels.surf fire
Egem_CT_6_1-labels.surf setViewerMask 65535

set hideNewModules 0
create HxDisplaySurface {SurfaceView}
SurfaceView setIconPosition 369 150
SurfaceView data connect Egem_CT_6_1-labels.surf
SurfaceView colormap setDefaultColor 1 0.1 0.1
SurfaceView colormap setDefaultAlpha 0.500000
SurfaceView fire
SurfaceView drawStyle setValue 1
SurfaceView drawStyle setSpecularLighting 1
SurfaceView drawStyle setTexture 0
SurfaceView drawStyle setAlphaMode 1
SurfaceView drawStyle setNormalBinding 0
SurfaceView drawStyle setCullingMode 0
SurfaceView drawStyle setSortingMode 1
SurfaceView selectionMode setValue 0 0
SurfaceView Patch setMinMax 0 1
SurfaceView Patch setButtons 1
SurfaceView Patch setIncrement 1
SurfaceView Patch setValue 0
SurfaceView Patch setSubMinMax 0 1
SurfaceView BoundaryId setValue 0 -1
SurfaceView materials setValue 0 1
SurfaceView materials setValue 1 0
SurfaceView colorMode setValue 0
SurfaceView baseTrans setMinMax 0 1
SurfaceView baseTrans setButtons 0
SurfaceView baseTrans setIncrement 0.1
SurfaceView baseTrans setValue 0.8
SurfaceView baseTrans setSubMinMax 0 1
SurfaceView VRMode setValue 0 0
SurfaceView fire
SurfaceView hideBox 1
{SurfaceView} selectTriangles zab HIJMONMOEBANAAAAAIAECAJLNJDPNFFJMCENBPJAIAAEAAAAAAHGPFHFAAAAOAJJKKMOAAAMLHHGEM
SurfaceView fire
SurfaceView setViewerMask 65535

set hideNewModules 0


viewer 0 setCameraPosition 1332.96 849.77 814.428
viewer 0 setCameraOrientation 0.326355 0.497469 0.803752 1.70272
viewer 0 setCameraFocalDistance 681.225
viewer 0 setAutoRedraw 1
viewer 0 redraw

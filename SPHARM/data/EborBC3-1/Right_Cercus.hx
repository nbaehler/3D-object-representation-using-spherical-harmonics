# Amira Script
remove -all
remove glow.col Ebor_BC_3_1.bmp Ebor_BC_3_1-labels OrthoSlice SurfaceGen

# Create viewers
viewer setVertical 1

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
[ load -bmp +box 0 1657.15 0 1404.15 0 822.25 +mode 1 ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0245.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0246.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0247.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0248.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0249.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0250.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0251.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0252.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0253.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0254.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0255.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0256.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0257.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0258.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0259.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0260.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0261.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0262.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0263.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0264.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0265.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0266.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0267.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0268.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0269.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0270.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0271.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0272.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0273.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0274.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0275.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0276.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0277.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0278.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0279.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0280.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0281.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0282.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0283.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0284.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0285.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0286.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0287.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0288.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0289.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0290.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0291.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0292.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0293.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0294.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0295.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0296.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0297.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0298.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0299.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0300.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0301.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0302.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0303.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0304.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0305.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0306.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0307.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0308.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0309.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0310.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0311.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0312.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0313.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0314.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0315.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0316.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0317.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0318.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0319.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0320.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0321.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0322.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0323.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0324.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0325.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0326.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0327.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0328.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0329.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0330.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0331.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0332.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0333.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0334.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0335.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0336.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0337.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0338.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0339.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0340.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0341.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0342.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0343.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0344.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0345.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0346.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0347.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0348.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0349.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0350.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0351.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0352.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0353.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0354.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0355.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0356.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0357.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0358.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0359.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0360.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0361.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0362.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0363.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0364.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0365.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0366.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0367.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0368.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0369.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0370.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0371.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0372.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0373.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0374.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0375.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0376.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0377.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0378.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0379.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0380.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0381.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0382.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0383.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0384.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0385.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0386.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0387.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0388.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0389.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0390.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0391.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0392.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0393.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0394.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0395.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0396.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0397.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0398.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0399.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0400.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0401.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0402.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0403.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0404.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0405.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0406.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0407.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0408.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0409.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0410.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0411.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0412.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0413.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0414.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0415.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0416.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0417.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0418.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0419.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0420.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0421.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0422.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0423.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0424.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0425.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0426.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0427.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0428.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0429.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0430.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0431.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0432.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0433.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0434.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0435.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0436.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0437.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0438.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0439.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0440.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0441.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0442.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0443.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0444.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0445.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0446.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0447.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0448.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0449.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0450.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0451.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0452.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0453.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0454.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0455.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0456.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0457.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0458.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0459.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0460.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0461.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0462.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0463.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0464.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0465.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0466.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0467.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0468.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0469.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0470.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0471.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0472.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0473.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0474.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0475.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0476.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0477.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0478.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0479.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0480.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0481.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0482.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0483.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0484.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0485.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0486.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0487.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0488.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0489.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0490.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0491.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0492.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0493.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0494.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0495.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0496.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0497.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0498.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0499.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0500.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0501.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0502.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0503.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0504.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0505.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0506.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0507.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0508.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0509.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0510.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0511.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0512.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0513.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0514.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0515.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0516.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0517.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0518.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0519.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0520.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0521.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0522.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0523.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0524.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0525.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0526.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0527.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0528.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0529.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0530.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0531.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0532.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0533.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0534.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0535.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0536.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0537.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0538.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0539.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0540.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0541.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0542.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0543.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0544.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0545.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0546.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0547.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0548.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0549.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0550.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0551.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0552.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0553.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0554.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0555.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0556.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0557.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0558.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0559.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0560.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0561.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0562.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0563.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0564.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0565.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0566.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0567.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0568.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0569.bmp ${SCRIPTDIR}/../Reconstruction/ebor_bc_3_1__rec0570.bmp ] setLabel Ebor_BC_3_1.bmp
Ebor_BC_3_1.bmp setIconPosition 21 10
Ebor_BC_3_1.bmp fire
Ebor_BC_3_1.bmp fire
Ebor_BC_3_1.bmp setViewerMask 65535

set hideNewModules 0
[ load ${SCRIPTDIR}/Right_Cercus-files/Ebor_BC_3_1-labels ] setLabel Ebor_BC_3_1-labels
Ebor_BC_3_1-labels setIconPosition 21 30
Ebor_BC_3_1-labels ImageData connect Ebor_BC_3_1.bmp
Ebor_BC_3_1-labels fire
Ebor_BC_3_1-labels primary setValue 0 0
Ebor_BC_3_1-labels fire
Ebor_BC_3_1-labels setViewerMask 65535

set hideNewModules 0
create HxOrthoSlice {OrthoSlice}
OrthoSlice setIconPosition 185 13
OrthoSlice data connect Ebor_BC_3_1.bmp
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
OrthoSlice sliceNumber setMinMax 0 325
OrthoSlice sliceNumber setButtons 1
OrthoSlice sliceNumber setIncrement 1
OrthoSlice sliceNumber setValue 163
OrthoSlice sliceNumber setSubMinMax 0 325
OrthoSlice transparency setValue 0
OrthoSlice setFrameWidth 0
OrthoSlice setFrameColor 1 0.5 0
OrthoSlice frame 1
OrthoSlice fire

OrthoSlice fire
OrthoSlice setViewerMask 65534

set hideNewModules 0
create HxGMC {SurfaceGen}
SurfaceGen setIconPosition 160 60
SurfaceGen data connect Ebor_BC_3_1-labels
SurfaceGen fire
SurfaceGen smoothing setValue 0 3
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


viewer 0 setCameraPosition -304.417 1131.33 319.037
viewer 0 setCameraOrientation -0.591444 0.530787 0.607008 3.8138
viewer 0 setCameraFocalDistance 843.375
viewer 0 setAutoRedraw 1
viewer 0 redraw

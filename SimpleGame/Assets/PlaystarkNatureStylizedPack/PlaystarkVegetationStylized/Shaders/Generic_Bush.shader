// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Playstark/Generic Bush"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[NoScaleOffset]_MainTex("MainTex", 2D) = "white" {}
		_AmbientOcclusion("AmbientOcclusion", Range( 0 , 1)) = 0
		_MaxWindStrength("MaxWindStrength", Range( 0 , 1)) = 0.1164738
		_WindAmplitudeMultiplier("WindAmplitudeMultiplier", Float) = 1
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_Tint("Tint", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TreeTransparentCutout"  "Queue" = "AlphaTest+0" }
		LOD 200
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 4.6
		#pragma multi_compile_instancing
		#include "VS_InstancedIndirect.cginc"
		#pragma instancing_options procedural:setupScale forwardadd
		#pragma multi_compile GPU_FRUSTUM_ON __
		#pragma exclude_renderers vulkan xbox360 xboxone ps4 psp2 n3ds wiiu 
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows noshadow nolightmap  nodynlightmap nodirlightmap nofog dithercrossfade vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _WindVectors;
		uniform float _WindAmplitudeMultiplier;
		uniform float _WindAmplitude;
		uniform float _WindSpeed;
		uniform float4 _WindDirection;
		uniform float _MaxWindStrength;
		uniform float _WindStrength;
		uniform float _TrunkWindSpeed;
		uniform float _TrunkWindSwinging;
		uniform float _TrunkWindWeight;
		uniform sampler2D _MainTex;
		uniform float4 _Tint;
		uniform float _WindDebug;
		uniform float _Smoothness;
		uniform float _AmbientOcclusion;
		uniform float _Cutoff = 0.5;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float temp_output_60_0 = ( ( _WindSpeed * 0.05 ) * _Time.w );
			float2 appendResult249 = (float2(_WindDirection.x , _WindDirection.z));
			float3 WindVectors99 = UnpackNormal( tex2Dlod( _WindVectors, float4( ( ( _WindAmplitudeMultiplier * _WindAmplitude * ( (ase_worldPos).xz * 0.01 ) ) + ( temp_output_60_0 * appendResult249 ) ), 0, 0.0) ) );
			float3 ase_objectScale = float3( length( unity_ObjectToWorld[ 0 ].xyz ), length( unity_ObjectToWorld[ 1 ].xyz ), length( unity_ObjectToWorld[ 2 ].xyz ) );
			float3 appendResult250 = (float3(_WindDirection.x , 0.0 , _WindDirection.z));
			float3 _Vector2 = float3(1,1,1);
			float3 break282 = ( ( (float3( 0,0,0 ) + (sin( ( ( temp_output_60_0 * ( _TrunkWindSpeed / ase_objectScale ) ) * appendResult250 ) ) - ( float3(-1,-1,-1) + _TrunkWindSwinging )) * (_Vector2 - float3( 0,0,0 )) / (_Vector2 - ( float3(-1,-1,-1) + _TrunkWindSwinging ))) * _TrunkWindWeight ) * v.color.b );
			float3 appendResult283 = (float3(break282.x , 0.0 , break282.z));
			float3 Wind17 = ( ( ( WindVectors99 * v.color.a ) * _MaxWindStrength * _WindStrength ) + appendResult283 );
			v.vertex.xyz += Wind17;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_MainTex19 = i.uv_texcoord;
			float4 tex2DNode19 = tex2D( _MainTex, uv_MainTex19 );
			float4 transform204 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float4 lerpResult20 = lerp( tex2DNode19 , _Tint , ( _Tint.a * ( ( 1.0 - i.vertexColor.g ) * frac( ( ( transform204.x + transform204.y ) + transform204.z ) ) ) ));
			float4 temp_cast_0 = (1.0).xxxx;
			float4 clampResult55 = clamp( lerpResult20 , float4( 0,0,0,0 ) , temp_cast_0 );
			float4 Color56 = clampResult55;
			float3 ase_worldPos = i.worldPos;
			float temp_output_60_0 = ( ( _WindSpeed * 0.05 ) * _Time.w );
			float2 appendResult249 = (float2(_WindDirection.x , _WindDirection.z));
			float3 WindVectors99 = UnpackNormal( tex2D( _WindVectors, ( ( _WindAmplitudeMultiplier * _WindAmplitude * ( (ase_worldPos).xz * 0.01 ) ) + ( temp_output_60_0 * appendResult249 ) ) ) );
			float4 lerpResult97 = lerp( Color56 , float4( WindVectors99 , 0.0 ) , _WindDebug);
			o.Albedo = lerpResult97.rgb;
			o.Smoothness = _Smoothness;
			float lerpResult53 = lerp( 1.0 , 0.0 , ( _AmbientOcclusion * ( 1.0 - i.vertexColor.r ) ));
			float AmbientOcclusion218 = lerpResult53;
			o.Occlusion = AmbientOcclusion218;
			o.Alpha = 1;
			float Alpha31 = tex2DNode19.a;
			float lerpResult101 = lerp( Alpha31 , 1.0 , _WindDebug);
			clip( lerpResult101 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18000
-1566;101;1394;847;6484.307;2431.857;6.430644;True;False
Node;AmplifyShaderEditor.CommentaryNode;238;-3667.135,-2121.826;Inherit;False;2833.298;786.479;Comment;22;5;106;59;4;210;90;86;60;209;211;89;212;91;102;99;10;237;15;16;249;284;315;Leaf wind animation;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;239;-3652.349,-1120.615;Inherit;False;2848.898;709.3215;Comment;19;283;282;118;143;152;206;144;170;150;242;154;148;171;250;141;194;87;142;168;Global wind animation;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-3617.135,-1656.65;Float;False;Global;_WindSpeed;_WindSpeed;7;0;Create;True;0;0;False;0;0.3;0.1947;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;106;-3551.274,-1578.427;Float;False;Constant;_Float0;Float 0;10;0;Create;True;0;0;False;0;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectScaleNode;168;-3542.756,-711.0254;Inherit;False;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;142;-3602.349,-812.4175;Float;False;Global;_TrunkWindSpeed;_TrunkWindSpeed;10;0;Create;True;0;0;False;0;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;4;-3317.041,-1537.348;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;-3238.875,-1649.827;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-3016.635,-1601.05;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;194;-3326.955,-793.326;Inherit;False;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;241;-3248.676,-272.9693;Inherit;False;2451.669;1115.413;Comment;16;56;31;55;105;20;30;245;203;24;19;23;204;327;328;329;330;Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;5;-3614.591,-1937.509;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector4Node;87;-3621.655,-1034.322;Float;False;Global;_WindDirection;_WindDirection;9;0;Create;True;0;0;False;0;1,0,0,0;0,0,-1,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;141;-3036.651,-1070.615;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;86;-3364.207,-1950.907;Inherit;False;FLOAT2;0;2;2;2;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;204;-3198.676,271.0515;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;250;-3275.214,-1007.126;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;210;-3385.156,-1825.827;Float;False;Constant;_Float7;Float 7;10;0;Create;True;0;0;False;0;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;209;-3165.303,-1949.893;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-2979.641,279.4307;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;249;-2889.935,-1489.43;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;171;-3051.457,-701.4264;Float;False;Global;_TrunkWindSwinging;_TrunkWindSwinging;10;0;Create;True;0;0;False;0;0;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;211;-3016.671,-2071.827;Float;False;Property;_WindAmplitudeMultiplier;WindAmplitudeMultiplier;5;0;Create;True;0;0;False;0;1;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;315;-2985.974,-1987.627;Float;False;Global;_WindAmplitude;_WindAmplitude;12;0;Create;True;0;0;False;0;2;1.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;148;-2762.254,-1021.821;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;154;-2806.556,-871.7242;Float;False;Constant;_Vector1;Vector 1;10;0;Create;True;0;0;False;0;-1,-1,-1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;-2696.375,-1615.427;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VertexColorNode;245;-3179.243,85.25092;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;24;-2831.143,323.1302;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;242;-2583.609,-635.626;Float;False;Constant;_Vector2;Vector 2;10;0;Create;True;0;0;False;0;1,1,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SinOpNode;150;-2574.953,-1009.321;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;212;-2693.671,-1932.827;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;170;-2568.457,-811.4264;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;329;-2884.58,134.8216;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;152;-2133.854,-1017.122;Inherit;False;5;0;FLOAT3;0,0,0;False;1;FLOAT3;-1,-1,-1;False;2;FLOAT3;1,1,1;False;3;FLOAT3;0,0,0;False;4;FLOAT3;1,1,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;144;-1989.15,-826.6202;Float;False;Global;_TrunkWindWeight;_TrunkWindWeight;10;0;Create;True;0;0;False;0;2;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;203;-2689.376,319.1513;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;91;-2460.575,-1799.027;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-2497.99,160.7763;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;206;-1848.998,-713.835;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;19;-3188.544,-221.6694;Inherit;True;Property;_MainTex;MainTex;1;1;[NoScaleOffset];Create;True;0;0;False;0;-1;None;70c02ae361e667d4795b8ae544661481;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;327;-2642.629,-40.55383;Float;False;Property;_Tint;Tint;7;0;Create;True;0;0;False;0;0,0,0,0;0.1233978,0.39227,0.443396,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;102;-2255.48,-1831.627;Inherit;True;Global;_WindVectors;_WindVectors;4;0;Create;True;0;0;False;0;-1;None;0f28b996ff888ec4f9459d2e53004d6f;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;143;-1743.643,-992.5203;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;240;-2246.501,1124.849;Inherit;False;1461.06;358.5759;Comment;7;47;50;49;51;108;53;218;AO;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;328;-2275.109,59.09119;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;10;-1829.957,-1705.569;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;47;-2196.501,1281.423;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;118;-1562.851,-991.6213;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;330;-2604.875,-166.2969;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;99;-1863.18,-1814.428;Float;False;WindVectors;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-1956,1190.424;Float;False;Property;_AmbientOcclusion;AmbientOcclusion;2;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;105;-1650.43,36.66455;Float;False;Constant;_Float3;Float 3;10;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;282;-1403.126,-987.1544;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;237;-1604.721,-1819.927;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1461.036,-1691.449;Float;False;Property;_MaxWindStrength;MaxWindStrength;3;0;Create;True;0;0;False;0;0.1164738;0.188;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;20;-2027.478,-55.00967;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;49;-1875.4,1333.424;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;284;-1459.256,-1595.309;Float;False;Global;_WindStrength;_WindStrength;12;0;Create;True;0;0;False;0;1;0.569;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-1102.023,-1806.348;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;100;-490.9563,-275.6743;Float;False;Global;_WindDebug;_WindDebug;10;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;283;-1102.564,-988.8111;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-1615.4,1287.923;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;108;-1548.041,1174.849;Float;False;Constant;_Float5;Float 5;10;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;55;-1322.497,-71.15502;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;274;-156.1185,71.1113;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;123;-564.3578,-1277.91;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;272;-178.1518,-540.8887;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-2872.081,-128.6166;Float;False;Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;56;-1007.576,-54.84016;Float;False;Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;53;-1351.5,1228.124;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;218;-1066.441,1308.546;Float;False;AmbientOcclusion;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;32;2.503998,-64.40088;Inherit;False;31;Alpha;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;273;-109.7907,-610.0359;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;17;-359.1269,-1283.735;Float;False;Wind;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;98;219.3051,-721.6776;Inherit;False;99;WindVectors;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;246.7924,-823.8511;Inherit;False;56;Color;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;271;-21.25233,150.8487;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;103;33.9621,24.42241;Float;False;Constant;_Float1;Float 1;10;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;97;602.4169,-706.1078;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;217;-64.46478,-151.5051;Inherit;False;218;AmbientOcclusion;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;254;-89.41714,-236.6956;Float;False;Property;_Smoothness;Smoothness;6;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;18;581.2745,41.64254;Inherit;False;17;Wind;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;101;253.1581,10.25581;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;991.35,-341.3243;Float;False;True;-1;6;ASEMaterialInspector;200;0;Standard;Playstark/Generic Bush;False;False;False;False;False;False;True;True;True;True;False;False;True;False;False;False;True;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;TreeTransparentCutout;;AlphaTest;All;7;d3d9;d3d11_9x;d3d11;glcore;gles;gles3;metal;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;0;20.3;10;25;True;0.5;False;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;1;False;-1;1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;200;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;3;Include;VS_InstancedIndirect.cginc;False;;Custom;Pragma;instancing_options procedural:setupScale forwardadd;False;;Custom;Pragma;multi_compile GPU_FRUSTUM_ON __;False;;Custom;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;90;0;59;0
WireConnection;90;1;106;0
WireConnection;60;0;90;0
WireConnection;60;1;4;4
WireConnection;194;0;142;0
WireConnection;194;1;168;0
WireConnection;141;0;60;0
WireConnection;141;1;194;0
WireConnection;86;0;5;0
WireConnection;250;0;87;1
WireConnection;250;2;87;3
WireConnection;209;0;86;0
WireConnection;209;1;210;0
WireConnection;23;0;204;1
WireConnection;23;1;204;2
WireConnection;249;0;87;1
WireConnection;249;1;87;3
WireConnection;148;0;141;0
WireConnection;148;1;250;0
WireConnection;89;0;60;0
WireConnection;89;1;249;0
WireConnection;24;0;23;0
WireConnection;24;1;204;3
WireConnection;150;0;148;0
WireConnection;212;0;211;0
WireConnection;212;1;315;0
WireConnection;212;2;209;0
WireConnection;170;0;154;0
WireConnection;170;1;171;0
WireConnection;329;0;245;2
WireConnection;152;0;150;0
WireConnection;152;1;170;0
WireConnection;152;2;242;0
WireConnection;152;4;242;0
WireConnection;203;0;24;0
WireConnection;91;0;212;0
WireConnection;91;1;89;0
WireConnection;30;0;329;0
WireConnection;30;1;203;0
WireConnection;102;1;91;0
WireConnection;143;0;152;0
WireConnection;143;1;144;0
WireConnection;328;0;327;4
WireConnection;328;1;30;0
WireConnection;118;0;143;0
WireConnection;118;1;206;3
WireConnection;330;0;19;0
WireConnection;99;0;102;0
WireConnection;282;0;118;0
WireConnection;237;0;99;0
WireConnection;237;1;10;4
WireConnection;20;0;330;0
WireConnection;20;1;327;0
WireConnection;20;2;328;0
WireConnection;49;0;47;1
WireConnection;15;0;237;0
WireConnection;15;1;16;0
WireConnection;15;2;284;0
WireConnection;283;0;282;0
WireConnection;283;2;282;2
WireConnection;51;0;50;0
WireConnection;51;1;49;0
WireConnection;55;0;20;0
WireConnection;55;2;105;0
WireConnection;274;0;100;0
WireConnection;123;0;15;0
WireConnection;123;1;283;0
WireConnection;272;0;100;0
WireConnection;31;0;19;4
WireConnection;56;0;55;0
WireConnection;53;0;108;0
WireConnection;53;2;51;0
WireConnection;218;0;53;0
WireConnection;273;0;272;0
WireConnection;17;0;123;0
WireConnection;271;0;274;0
WireConnection;97;0;57;0
WireConnection;97;1;98;0
WireConnection;97;2;273;0
WireConnection;101;0;32;0
WireConnection;101;1;103;0
WireConnection;101;2;271;0
WireConnection;0;0;97;0
WireConnection;0;4;254;0
WireConnection;0;5;217;0
WireConnection;0;10;101;0
WireConnection;0;11;18;0
ASEEND*/
//CHKSM=094BAC5C13B8085E06FCC84131DBE6ACD82FCF35
// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Playstark/StandardTree"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.9
		[Toggle(_DETAIL_NORMAL_ON_ON)] _Detail_normal_ON("Detail_normal_ON", Float) = 0
		_MainTex("MainTex", 2D) = "white" {}
		_SecondaryTex("SecondaryTex", 2D) = "white" {}
		_BumpMap("BumpMap", 2D) = "bump" {}
		_COLORfront("COLOR front", Color) = (1,0.5,0,0.184)
		_Tiling("Tiling", Float) = 1
		_MaxWindStrength("MaxWindStrength", Range( 0 , 1)) = 0.1164738
		_DetailLevel("Detail Level", Float) = 1
		_DetailNormal("Detail Normal", 2D) = "bump" {}
		_GradientBrightness("GradientBrightness", Range( 0 , 2)) = 1
		_WindAmplitudeMultiplier("WindAmplitudeMultiplier", Float) = 1
		_Float3("Float 3", Range( 0 , 2)) = 1.209817
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TreeTransparentCutout"  "Queue" = "AlphaTest+0" }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#pragma target 4.6
		#pragma multi_compile_instancing
		#pragma shader_feature _DETAIL_NORMAL_ON_ON
		#include "VS_InstancedIndirect.cginc"
		#pragma instancing_options assumeuniformscaling lodfade maxcount:50 procedural:setup forwardadd
		#pragma multi_compile GPU_FRUSTUM_ON __
		#pragma exclude_renderers vulkan xbox360 psp2 n3ds wiiu 
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows nolightmap  nodynlightmap nodirlightmap nofog dithercrossfade vertex:vertexDataFunc 
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
		uniform sampler2D _BumpMap;
		uniform float4 _BumpMap_ST;
		uniform float _DetailLevel;
		uniform sampler2D _DetailNormal;
		uniform float _Tiling;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _GradientBrightness;
		uniform sampler2D _SecondaryTex;
		uniform float4 _SecondaryTex_ST;
		uniform float _Float3;
		uniform float4 _COLORfront;
		uniform float _Cutoff = 0.9;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float temp_output_165_0 = ( ( _WindSpeed * 0.05 ) * _Time.w );
			float2 appendResult184 = (float2(_WindDirection.x , _WindDirection.z));
			float3 myVarName182 = UnpackNormal( tex2Dlod( _WindVectors, float4( ( ( _WindAmplitudeMultiplier * _WindAmplitude * ( (ase_worldPos).xz * 0.01 ) ) + ( temp_output_165_0 * appendResult184 ) ), 0, 0.0) ) );
			float3 ase_objectScale = float3( length( unity_ObjectToWorld[ 0 ].xyz ), length( unity_ObjectToWorld[ 1 ].xyz ), length( unity_ObjectToWorld[ 2 ].xyz ) );
			float3 appendResult204 = (float3(_WindDirection.x , 0.0 , _WindDirection.z));
			float3 _Vector5 = float3(1,1,1);
			float3 break167 = ( ( (float3( 0,0,0 ) + (sin( ( ( temp_output_165_0 * ( _TrunkWindSpeed / ase_objectScale ) ) * appendResult204 ) ) - ( float3(-1,-1,-1) + _TrunkWindSwinging )) * (_Vector5 - float3( 0,0,0 )) / (_Vector5 - ( float3(-1,-1,-1) + _TrunkWindSwinging ))) * _TrunkWindWeight ) * v.color.b );
			float3 appendResult161 = (float3(break167.x , 0.0 , break167.z));
			float3 lerpResult261 = lerp( ( ( ( myVarName182 * v.color.b ) * _MaxWindStrength * _WindStrength ) + appendResult161 ) , appendResult161 , v.color.g);
			float3 Wind175 = lerpResult261;
			v.vertex.xyz += Wind175;
			float3 ase_vertexNormal = v.normal.xyz;
			float3 _Vector0 = float3(0,1,0);
			float clampResult278 = clamp( pow( ( distance( ase_worldPos , _WorldSpaceCameraPos ) / 160.0 ) , 5.0 ) , 0.0 , 1.0 );
			float Distance279 = clampResult278;
			float clampResult287 = clamp( Distance279 , 0.1 , 0.5 );
			float3 lerpResult235 = lerp( ase_vertexNormal , _Vector0 , clampResult287);
			v.normal = lerpResult235;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_BumpMap = i.uv_texcoord * _BumpMap_ST.xy + _BumpMap_ST.zw;
			float3 tex2DNode46 = UnpackNormal( tex2D( _BumpMap, uv_BumpMap ) );
			float3 appendResult242 = (float3(0.0 , 0.0 , 1.0));
			float temp_output_246_0 = ( 1.0 - i.vertexColor.g );
			float3 lerpResult268 = lerp( tex2DNode46 , appendResult242 , temp_output_246_0);
			float2 appendResult138 = (float2(_Tiling , _Tiling));
			float2 uv_TexCoord147 = i.uv_texcoord * appendResult138;
			float3 tex2DNode135 = UnpackScaleNormal( tex2D( _DetailNormal, uv_TexCoord147 ), _DetailLevel );
			float3 appendResult146 = (float3(( tex2DNode46.r + tex2DNode135.r ) , ( tex2DNode46.g + tex2DNode135.g ) , 1.0));
			float3 lerpResult243 = lerp( appendResult146 , appendResult242 , temp_output_246_0);
			#ifdef _DETAIL_NORMAL_ON_ON
				float3 staticSwitch267 = lerpResult243;
			#else
				float3 staticSwitch267 = lerpResult268;
			#endif
			float3 Normals113 = staticSwitch267;
			o.Normal = Normals113;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode45 = tex2D( _MainTex, uv_MainTex );
			float4 lerpResult85 = lerp( ( tex2DNode45 * _GradientBrightness ) , tex2DNode45 , i.vertexColor.b);
			float4 Trunk247 = lerpResult85;
			float2 uv_SecondaryTex = i.uv_texcoord * _SecondaryTex_ST.xy + _SecondaryTex_ST.zw;
			float4 tex2DNode207 = tex2D( _SecondaryTex, uv_SecondaryTex );
			float4 lerpResult216 = lerp( ( tex2DNode207 * _Float3 ) , tex2DNode207 , i.vertexColor.r);
			float3 ase_worldPos = i.worldPos;
			float clampResult278 = clamp( pow( ( distance( ase_worldPos , _WorldSpaceCameraPos ) / 160.0 ) , 5.0 ) , 0.0 , 1.0 );
			float Distance279 = clampResult278;
			float4 transform208 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float4 lerpResult219 = lerp( lerpResult216 , _COLORfront , ( ( 1.0 - Distance279 ) * ( _COLORfront.a * frac( ( ( transform208.x + transform208.y ) + transform208.z ) ) ) ));
			float4 temp_cast_0 = (1.0).xxxx;
			float4 clampResult220 = clamp( lerpResult219 , float4( 0,0,0,0 ) , temp_cast_0 );
			float4 Bush206 = clampResult220;
			float4 lerpResult236 = lerp( Trunk247 , Bush206 , ( 1.0 - i.vertexColor.g ));
			float clampResult291 = clamp( ( 1.0 - Distance279 ) , 0.6 , 1.0 );
			float4 Albedo115 = ( lerpResult236 * clampResult291 );
			o.Albedo = Albedo115.rgb;
			o.Alpha = 1;
			float Alpha214 = tex2DNode207.a;
			half Opacity109 = tex2DNode45.a;
			float lerpResult240 = lerp( Alpha214 , Opacity109 , i.vertexColor.g);
			clip( lerpResult240 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18000
-1566;107;1394;841;2235.64;1677.107;5.390126;True;False
Node;AmplifyShaderEditor.WorldSpaceCameraPos;271;-284.0789,2359.949;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;272;-222.5633,2183.494;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;276;85.20502,2371.4;Float;False;Constant;_TransitionDistance;Transition Distance;21;0;Create;True;0;0;False;0;160;88;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;273;113.5881,2173.114;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;154;-301.578,-4188.73;Inherit;False;2833.298;786.479;Comment;25;197;196;195;193;191;190;189;188;187;186;185;184;182;180;179;166;165;164;162;251;254;255;259;260;264;Leaf wind animation;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;155;-289.87,-3165.973;Inherit;False;2848.898;709.3215;Comment;23;204;203;201;200;199;198;178;177;176;174;172;171;170;169;167;161;159;158;157;253;256;257;258;Global wind animation;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;205;-274.0987,-2229.722;Inherit;False;2451.669;817.7365;Comment;19;221;220;219;218;217;216;215;214;213;212;211;210;209;208;207;206;283;285;286;Bush;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;274;482.1506,2185.114;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;277;106.5517,2473.506;Float;False;Constant;_TransitionFallof;Transition Fallof;22;0;Create;True;0;0;False;0;5;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;254;-258.4509,-3750.526;Float;False;Global;_WindSpeed;_WindSpeed;7;0;Create;True;0;0;False;0;0.3;0.1947;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;189;-185.7171,-3645.331;Float;False;Constant;_Float10;Float 10;10;0;Create;True;0;0;False;0;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;208;-229.8248,-1611.173;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;253;-222.5291,-2842.98;Float;False;Global;_TrunkWindSpeed;_TrunkWindSpeed;10;0;Create;True;0;0;False;0;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;188;48.51701,-3604.252;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;191;126.683,-3716.731;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectScaleNode;170;-180.277,-2756.383;Inherit;False;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PowerNode;275;699.3459,2197.715;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;210;44.60896,-1629.015;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;278;966.9836,2183.851;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;187;-249.0341,-4004.413;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;165;348.9229,-3667.954;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;256;-231.2903,-3089.488;Float;False;Global;_WindDirection;_WindDirection;9;0;Create;True;0;0;False;0;1,0,0,0;0,0,-1,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;203;35.525,-2838.684;Inherit;False;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;204;87.266,-3052.484;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;199;325.8289,-3115.973;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;166;1.351025,-4017.811;Inherit;False;FLOAT2;0;2;2;2;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;209;241.738,-1600.905;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;279;1180.461,2184.875;Float;False;Distance;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;190;-19.59795,-3892.731;Float;False;Constant;_Float11;Float 11;10;0;Create;True;0;0;False;0;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;159;600.2259,-3067.179;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;157;555.9239,-2917.082;Float;False;Constant;_Vector4;Vector 4;10;0;Create;True;0;0;False;0;-1,-1,-1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;265;-255.2544,454.2136;Inherit;False;2303.161;612.2041;Normal;16;113;267;268;243;146;242;245;246;135;46;136;153;141;144;138;147;Normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;179;200.255,-4016.797;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;184;475.6228,-3556.334;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;257;267.7097,-2771.488;Float;False;Global;_TrunkWindSwinging;_TrunkWindSwinging;10;0;Create;True;0;0;False;0;0;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;180;348.8867,-4138.731;Float;False;Property;_WindAmplitudeMultiplier;WindAmplitudeMultiplier;14;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;211;-45.44407,-1960.995;Float;False;Property;_Float3;Float 3;15;0;Create;True;0;0;False;0;1.209817;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;207;-233.8439,-2167.467;Inherit;True;Property;_SecondaryTex;SecondaryTex;3;0;Create;True;0;0;False;0;-1;None;7875b624fe7c369479c689a543e4e203;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;283;671.2253,-1551.73;Inherit;False;279;Distance;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;255;411.5488,-4054.526;Float;False;Global;_WindAmplitude;_WindAmplitude;12;0;Create;True;0;0;False;0;2;1.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;213;487.0414,-1820.754;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;217;694.3528,-1939.176;Float;False;Property;_COLORfront;COLOR front;5;0;Create;True;0;0;False;0;1,0.5,0,0.184;1,0.5,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;136;-205.2544,659.6707;Float;False;Property;_Tiling;Tiling;6;0;Create;True;0;0;False;0;1;3.74;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;248;-266.5661,-1252.258;Inherit;False;1618.007;637.7823;Trunk;7;45;109;87;86;247;85;117;Trunk;1,1,1,1;0;0
Node;AmplifyShaderEditor.VertexColorNode;212;54.63717,-1860.786;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;215;350.5282,-2173.206;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;201;778.871,-2680.984;Float;False;Constant;_Vector5;Vector 5;10;0;Create;True;0;0;False;0;1,1,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SinOpNode;172;787.527,-3054.679;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;286;880.8728,-1550.779;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;218;997.698,-1805.964;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;162;669.1829,-3682.331;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;193;671.8868,-3999.731;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;198;794.0231,-2856.784;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;195;904.9832,-3865.931;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;216;649.5458,-2047.302;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;177;1228.626,-3062.48;Inherit;False;5;0;FLOAT3;0,0,0;False;1;FLOAT3;-1,-1,-1;False;2;FLOAT3;1,1,1;False;3;FLOAT3;0,0,0;False;4;FLOAT3;1,1,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;87;84.67827,-935.2809;Float;False;Property;_GradientBrightness;GradientBrightness;13;0;Create;True;0;0;False;0;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;258;1191.355,-2865.3;Float;False;Global;_TrunkWindWeight;_TrunkWindWeight;10;0;Create;True;0;0;False;0;2;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;285;1186.873,-1829.779;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;138;-37.45448,653.8707;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;45;-216.5661,-1202.258;Inherit;True;Property;_MainTex;MainTex;2;0;Create;True;0;0;False;0;-1;a693dd0ca8ad76c4eab40acb0b606262;7875b624fe7c369479c689a543e4e203;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;117;605.3123,-938.4756;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;147;129.3648,756.7747;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;176;1241.555,-2780.356;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;219;1342.532,-2034.151;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;153;143.8311,916.8914;Float;False;Property;_DetailLevel;Detail Level;9;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;178;1618.836,-3037.878;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;264;1076.81,-3940.624;Inherit;True;Global;_WindVectors;_WindVectors;10;0;Create;True;0;0;False;0;-1;None;0f28b996ff888ec4f9459d2e53004d6f;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;575.4547,-1144.103;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;221;1505.85,-1763.344;Float;False;Constant;_Float14;Float 14;10;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;46;566.2933,520.3536;Inherit;True;Property;_BumpMap;BumpMap;4;0;Create;True;0;0;False;0;-1;None;d0d9fc492bc11db47b7eafd2450d9ce1;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;85;883.9475,-1040.026;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;135;563.7293,735.0908;Inherit;True;Property;_DetailNormal;Detail Normal;11;0;Create;True;0;0;False;0;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;164;1386.76,-3724.22;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;220;1644.286,-2016.349;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;250;-262.6371,-461.4846;Inherit;False;1469.549;664.8506;Albedo;10;115;236;238;252;237;249;288;289;290;291;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;182;1502.377,-3881.332;Float;False;myVarName;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;158;1799.628,-3036.979;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;141;944.3179,548.104;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;186;1804.049,-3866.385;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;144;947.9895,699.6556;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;167;1959.353,-3032.512;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.VertexColorNode;249;-228.2371,-125.8995;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;247;1108.44,-1022.795;Float;False;Trunk;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;206;1975.755,-2037.858;Float;False;Bush;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;289;125.4465,-47.97515;Inherit;False;279;Distance;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;245;937.525,873.5176;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;259;1887.718,-3684.542;Float;False;Global;_WindStrength;_WindStrength;12;0;Create;True;0;0;False;0;1;0.569;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;260;1884.399,-3765.292;Float;False;Property;_MaxWindStrength;MaxWindStrength;7;0;Create;True;0;0;False;0;0.1164738;0.1164738;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;185;2263.535,-3873.252;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;161;2259.915,-3034.169;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;246;1140.472,877.4774;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;146;1129.287,554.6485;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;252;-25.75412,-333.1916;Inherit;False;247;Trunk;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;238;1.097522,-145.0196;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;237;-24.65993,-242.4845;Inherit;False;206;Bush;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;290;372.3372,-51.97527;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;242;1136.543,711.8212;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;236;352.2626,-294.4043;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;291;564.1085,-58.46777;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.6;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;262;2793.478,-3186.872;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;156;2752.229,-3545.944;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;243;1301.278,550.3135;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;268;1332.086,770.009;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;288;719.9476,-175.8565;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;267;1508.086,645.009;Float;False;Property;_Detail_normal_ON;Detail_normal_ON;1;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;214;100.8892,-2076.179;Float;False;Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;109;116.6754,-1104.726;Half;False;Opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;280;2712.139,676.5086;Inherit;False;279;Distance;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;261;3030.907,-3369.74;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;241;2451.127,-169.7817;Inherit;False;109;Opacity;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;133;2452.48,-260.0719;Inherit;False;214;Alpha;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;287;2914.743,776.0203;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;232;2284.518,249.9214;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;90;2457.745,-82.69811;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;231;2300.798,414.1258;Float;False;Constant;_Vector0;Vector 0;10;0;Create;True;0;0;False;0;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;115;956.3853,-299.8745;Float;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;113;1803.807,649.8133;Float;False;Normals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;222;-254.5576,1388.536;Inherit;False;1461.06;358.5759;Comment;7;229;228;227;226;225;224;223;AO;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;175;3283.407,-3372.479;Float;False;Wind;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;171;1092.703,-2590.397;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;233;2601.5,546.6998;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;234;2284.602,598.2757;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;114;2835.853,-321.6862;Inherit;False;113;Normals;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;112;2815.923,107.2357;Inherit;False;175;Wind;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;240;2817.337,-91.59035;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;116;2852.965,-522.1247;Inherit;False;115;Albedo;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;196;1619.858,-3597.989;Float;False;Property;_ToggleSwitch4;Toggle Switch4;17;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;251;1632.803,-3700.976;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;197;1338.482,-3536.183;Inherit;False;2;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;174;1561.995,-2726.594;Float;False;Property;_ToggleSwitch3;Toggle Switch3;16;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;169;1564.413,-2611.02;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;230;2494.783,798.5034;Float;False;Property;_FlatLighting;FlatLighting;12;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;225;641.4425,1500.536;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;226;49.4424,1452.536;Float;False;Property;_Float8;Float 8;8;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;228;932.9044,1500.913;Float;True;AmbientOcclusion;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;224;385.4426,1548.536;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;223;-190.5576,1548.536;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;227;129.4424,1596.536;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;229;449.4426,1436.536;Float;False;Constant;_Float12;Float 12;10;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;200;1901.626,-2648.846;Float;False;Property;_ToggleSwitch5;Toggle Switch5;18;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;235;2844.973,266.4513;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;270;3187.507,-301.7967;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Playstark/StandardTree;False;False;False;False;False;False;True;True;True;True;False;False;True;False;False;False;True;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.9;True;True;0;True;TreeTransparentCutout;;AlphaTest;All;9;d3d9;d3d11_9x;d3d11;glcore;gles;gles3;metal;xboxone;ps4;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;3;Include;VS_InstancedIndirect.cginc;False;;Custom;Pragma;instancing_options assumeuniformscaling lodfade maxcount:50 procedural:setup forwardadd;False;;Custom;Pragma;multi_compile GPU_FRUSTUM_ON __;False;;Custom;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;273;0;272;0
WireConnection;273;1;271;0
WireConnection;274;0;273;0
WireConnection;274;1;276;0
WireConnection;191;0;254;0
WireConnection;191;1;189;0
WireConnection;275;0;274;0
WireConnection;275;1;277;0
WireConnection;210;0;208;1
WireConnection;210;1;208;2
WireConnection;278;0;275;0
WireConnection;165;0;191;0
WireConnection;165;1;188;4
WireConnection;203;0;253;0
WireConnection;203;1;170;0
WireConnection;204;0;256;1
WireConnection;204;2;256;3
WireConnection;199;0;165;0
WireConnection;199;1;203;0
WireConnection;166;0;187;0
WireConnection;209;0;210;0
WireConnection;209;1;208;3
WireConnection;279;0;278;0
WireConnection;159;0;199;0
WireConnection;159;1;204;0
WireConnection;179;0;166;0
WireConnection;179;1;190;0
WireConnection;184;0;256;1
WireConnection;184;1;256;3
WireConnection;213;0;209;0
WireConnection;215;0;207;0
WireConnection;215;1;211;0
WireConnection;172;0;159;0
WireConnection;286;0;283;0
WireConnection;218;0;217;4
WireConnection;218;1;213;0
WireConnection;162;0;165;0
WireConnection;162;1;184;0
WireConnection;193;0;180;0
WireConnection;193;1;255;0
WireConnection;193;2;179;0
WireConnection;198;0;157;0
WireConnection;198;1;257;0
WireConnection;195;0;193;0
WireConnection;195;1;162;0
WireConnection;216;0;215;0
WireConnection;216;1;207;0
WireConnection;216;2;212;1
WireConnection;177;0;172;0
WireConnection;177;1;198;0
WireConnection;177;2;201;0
WireConnection;177;4;201;0
WireConnection;285;0;286;0
WireConnection;285;1;218;0
WireConnection;138;0;136;0
WireConnection;138;1;136;0
WireConnection;147;0;138;0
WireConnection;219;0;216;0
WireConnection;219;1;217;0
WireConnection;219;2;285;0
WireConnection;178;0;177;0
WireConnection;178;1;258;0
WireConnection;264;1;195;0
WireConnection;86;0;45;0
WireConnection;86;1;87;0
WireConnection;85;0;86;0
WireConnection;85;1;45;0
WireConnection;85;2;117;3
WireConnection;135;1;147;0
WireConnection;135;5;153;0
WireConnection;220;0;219;0
WireConnection;220;2;221;0
WireConnection;182;0;264;0
WireConnection;158;0;178;0
WireConnection;158;1;176;3
WireConnection;141;0;46;1
WireConnection;141;1;135;1
WireConnection;186;0;182;0
WireConnection;186;1;164;3
WireConnection;144;0;46;2
WireConnection;144;1;135;2
WireConnection;167;0;158;0
WireConnection;247;0;85;0
WireConnection;206;0;220;0
WireConnection;185;0;186;0
WireConnection;185;1;260;0
WireConnection;185;2;259;0
WireConnection;161;0;167;0
WireConnection;161;2;167;2
WireConnection;246;0;245;2
WireConnection;146;0;141;0
WireConnection;146;1;144;0
WireConnection;238;0;249;2
WireConnection;290;0;289;0
WireConnection;236;0;252;0
WireConnection;236;1;237;0
WireConnection;236;2;238;0
WireConnection;291;0;290;0
WireConnection;156;0;185;0
WireConnection;156;1;161;0
WireConnection;243;0;146;0
WireConnection;243;1;242;0
WireConnection;243;2;246;0
WireConnection;268;0;46;0
WireConnection;268;1;242;0
WireConnection;268;2;246;0
WireConnection;288;0;236;0
WireConnection;288;1;291;0
WireConnection;267;1;268;0
WireConnection;267;0;243;0
WireConnection;214;0;207;4
WireConnection;109;0;45;4
WireConnection;261;0;156;0
WireConnection;261;1;161;0
WireConnection;261;2;262;2
WireConnection;287;0;280;0
WireConnection;115;0;288;0
WireConnection;113;0;267;0
WireConnection;175;0;261;0
WireConnection;233;0;231;0
WireConnection;233;1;234;0
WireConnection;240;0;133;0
WireConnection;240;1;241;0
WireConnection;240;2;90;2
WireConnection;196;0;164;2
WireConnection;196;1;197;1
WireConnection;251;0;164;2
WireConnection;174;0;176;4
WireConnection;174;1;176;3
WireConnection;169;0;171;2
WireConnection;225;0;229;0
WireConnection;225;2;224;0
WireConnection;228;0;225;0
WireConnection;224;0;226;0
WireConnection;224;1;227;0
WireConnection;227;0;223;1
WireConnection;200;0;174;0
WireConnection;200;1;169;0
WireConnection;235;0;232;0
WireConnection;235;1;231;0
WireConnection;235;2;287;0
WireConnection;270;0;116;0
WireConnection;270;1;114;0
WireConnection;270;10;240;0
WireConnection;270;11;112;0
WireConnection;270;12;235;0
ASEEND*/
//CHKSM=C56F9A810802D27E866DEB9A15633955AB8E9647
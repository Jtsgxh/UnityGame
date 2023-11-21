// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Playstark/SporeFoliage"
{
	Properties
	{
		[NoScaleOffset]_MainTex("MainTex", 2D) = "white" {}
		[NoScaleOffset]_emit("emit", 2D) = "white" {}
		[NoScaleOffset]_BumpMap("BumpMap", 2D) = "bump" {}
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_AmbientOcclusion("AmbientOcclusion", Range( 0 , 1)) = 0
		_MaxWindStrength("MaxWindStrength", Range( 0 , 1)) = 0.1164738
		_Color_variation("Color_variation", Float) = 1
		_WindAmplitudeMultiplier("WindAmplitudeMultiplier", Float) = 1
		_Smoothness("Smoothness", Range( 0 , 1)) = 1
		_Emission_intensity("Emission_intensity", Float) = 1
		_DirectionXZ_Y("Direction-XZ_Y", Range( 0 , 1)) = 0
		_FlatLighting("FlatLighting", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TreeTransparentCutout"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 4.6
		#pragma multi_compile_instancing
		#include "VS_InstancedIndirect.cginc"
		#pragma instancing_options assumeuniformscaling lodfade maxcount:50 procedural:setup forwardadd
		#pragma multi_compile GPU_FRUSTUM_ON __
		#pragma exclude_renderers vulkan xbox360 xboxone ps4 psp2 n3ds wiiu 
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows nolightmap  nodynlightmap nodirlightmap nofog dithercrossfade vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float _WindSpeed;
		uniform float _TrunkWindSpeed;
		uniform float4 _WindDirection;
		uniform float _DirectionXZ_Y;
		uniform float _TrunkWindSwinging;
		uniform float _TrunkWindWeight;
		uniform sampler2D _WindVectors;
		uniform float _WindAmplitudeMultiplier;
		uniform float _WindAmplitude;
		uniform float _MaxWindStrength;
		uniform float _WindStrength;
		uniform float _FlatLighting;
		uniform sampler2D _BumpMap;
		uniform sampler2D _MainTex;
		uniform float _WindDebug;
		uniform float _Color_variation;
		uniform sampler2D _emit;
		uniform float _Emission_intensity;
		uniform float _Smoothness;
		uniform float _AmbientOcclusion;
		uniform float _Cutoff = 0.5;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			half temp_output_60_0 = ( ( _WindSpeed * 0.05 ) * _Time.w );
			float3 ase_objectScale = float3( length( unity_ObjectToWorld[ 0 ].xyz ), length( unity_ObjectToWorld[ 1 ].xyz ), length( unity_ObjectToWorld[ 2 ].xyz ) );
			half3 appendResult250 = (half3(_WindDirection.x , 0.0 , _WindDirection.z));
			half3 temp_cast_0 = (_WindDirection.y).xxx;
			half3 lerpResult408 = lerp( appendResult250 , temp_cast_0 , _DirectionXZ_Y);
			float3 _Vector2 = float3(1,1,1);
			half3 break282 = ( ( (float3( 0,0,0 ) + (sin( ( ( temp_output_60_0 * ( _TrunkWindSpeed / ase_objectScale ) ) * lerpResult408 ) ) - ( float3(-1,-1,-1) + _TrunkWindSwinging )) * (_Vector2 - float3( 0,0,0 )) / (_Vector2 - ( float3(-1,-1,-1) + _TrunkWindSwinging ))) * _TrunkWindWeight ) * v.color.b );
			half3 appendResult283 = (half3(break282.x , 0.0 , break282.z));
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			half2 temp_cast_1 = (ase_worldPos.y).xx;
			half2 lerpResult406 = lerp( (ase_worldPos).xz , temp_cast_1 , _DirectionXZ_Y);
			half2 appendResult249 = (half2(_WindDirection.x , _WindDirection.z));
			float3 WindVectors99 = UnpackNormal( tex2Dlod( _WindVectors, float4( ( ( _WindAmplitudeMultiplier * _WindAmplitude * ( lerpResult406 * 0.01 ) ) + ( temp_output_60_0 * appendResult249 ) ), 0, 0.0) ) );
			half3 lerpResult430 = lerp( appendResult283 , ( ( WindVectors99 * _MaxWindStrength * _WindStrength ) + appendResult283 ) , v.color.g);
			float3 Wind17 = lerpResult430;
			v.vertex.xyz += Wind17;
			half3 ase_vertexNormal = v.normal.xyz;
			float3 _Vector0 = float3(0,1,0);
			half3 lerpResult427 = lerp( ase_vertexNormal , _Vector0 , _FlatLighting);
			v.normal = lerpResult427;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_BumpMap62 = i.uv_texcoord;
			o.Normal = UnpackNormal( tex2D( _BumpMap, uv_BumpMap62 ) );
			float2 uv_MainTex19 = i.uv_texcoord;
			half4 tex2DNode19 = tex2D( _MainTex, uv_MainTex19 );
			half4 temp_cast_0 = (1.0).xxxx;
			half4 clampResult55 = clamp( tex2DNode19 , float4( 0,0,0,0 ) , temp_cast_0 );
			float4 Color56 = clampResult55;
			float3 ase_worldPos = i.worldPos;
			half2 temp_cast_1 = (ase_worldPos.y).xx;
			half2 lerpResult406 = lerp( (ase_worldPos).xz , temp_cast_1 , _DirectionXZ_Y);
			half temp_output_60_0 = ( ( _WindSpeed * 0.05 ) * _Time.w );
			half2 appendResult249 = (half2(_WindDirection.x , _WindDirection.z));
			float3 WindVectors99 = UnpackNormal( tex2D( _WindVectors, ( ( _WindAmplitudeMultiplier * _WindAmplitude * ( lerpResult406 * 0.01 ) ) + ( temp_output_60_0 * appendResult249 ) ) ) );
			half4 lerpResult97 = lerp( Color56 , half4( WindVectors99 , 0.0 ) , _WindDebug);
			o.Albedo = lerpResult97.rgb;
			half3 break381 = WindVectors99;
			half temp_output_382_0 = ( break381.x * break381.y );
			float2 uv_emit333 = i.uv_texcoord;
			float4 SSS45 = ( tex2D( _emit, uv_emit333 ) * _Emission_intensity );
			half4 clampResult405 = clamp( ( ( _Color_variation * temp_output_382_0 ) * SSS45 ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float4 emission_color386 = ( clampResult405 + SSS45 );
			o.Emission = emission_color386.rgb;
			o.Smoothness = _Smoothness;
			half lerpResult53 = lerp( 1.0 , 0.0 , ( _AmbientOcclusion * ( 1.0 - i.vertexColor.r ) ));
			float AmbientOcclusion218 = lerpResult53;
			o.Occlusion = AmbientOcclusion218;
			o.Alpha = 1;
			float Alpha31 = tex2DNode19.a;
			clip( Alpha31 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18000
-1747;58;1394;887;2796.481;1494.959;1.334502;True;False
Node;AmplifyShaderEditor.CommentaryNode;238;-4000.528,-2348.24;Inherit;False;2833.298;786.479;Comment;21;5;106;59;4;210;90;86;60;209;211;89;212;91;102;99;15;16;249;284;315;406;Leaf wind animation;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;239;-3957.72,-1217.98;Inherit;False;2848.898;709.3215;Comment;20;283;282;118;143;152;144;170;150;242;154;148;171;250;141;194;87;142;168;408;435;Global wind animation;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-3950.528,-1883.063;Float;False;Global;_WindSpeed;_WindSpeed;7;0;Create;True;0;0;False;0;0.3;0.1947;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;407;-4523.037,-2109.262;Float;False;Property;_DirectionXZ_Y;Direction-XZ_Y;11;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;106;-3884.667,-1804.84;Float;False;Constant;_Float0;Float 0;10;0;Create;True;0;0;False;0;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectScaleNode;168;-3848.127,-808.3901;Inherit;False;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector4Node;87;-3910.804,-1104.651;Float;False;Global;_WindDirection;_WindDirection;9;0;Create;True;0;0;False;0;1,0,0,0;0,0,-1,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;4;-3650.434,-1763.761;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;142;-3907.72,-909.7822;Float;False;Global;_TrunkWindSpeed;_TrunkWindSpeed;10;0;Create;True;0;0;False;0;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;5;-3963.563,-2262.073;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WireNode;415;-4234.708,-1170.322;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;-3572.268,-1876.24;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;250;-3580.585,-1104.491;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;86;-3781.729,-2258.333;Inherit;False;FLOAT2;0;2;2;2;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;194;-3632.326,-890.6907;Inherit;False;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;416;-4090.051,-976.4486;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-3350.028,-1827.463;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;408;-3351.25,-1019.661;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;141;-3342.022,-1167.98;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;406;-3708.474,-2162.269;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;210;-3718.549,-2052.24;Float;False;Constant;_Float7;Float 7;10;0;Create;True;0;0;False;0;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;211;-3350.064,-2298.24;Float;False;Property;_WindAmplitudeMultiplier;WindAmplitudeMultiplier;8;0;Create;True;0;0;False;0;1;1.09;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;209;-3498.696,-2176.306;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector3Node;154;-3111.927,-969.0889;Float;False;Constant;_Vector1;Vector 1;10;0;Create;True;0;0;False;0;-1,-1,-1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;249;-3223.328,-1715.843;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;171;-3197.828,-798.7911;Float;False;Global;_TrunkWindSwinging;_TrunkWindSwinging;10;0;Create;True;0;0;False;0;0;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;148;-3067.625,-1119.186;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;315;-3319.367,-2214.04;Float;False;Global;_WindAmplitude;_WindAmplitude;12;0;Create;True;0;0;False;0;2;1.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;-3029.768,-1841.84;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SinOpNode;150;-2880.324,-1106.686;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;212;-3027.064,-2159.24;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;170;-2873.828,-908.7911;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;242;-2888.98,-732.9907;Float;False;Constant;_Vector2;Vector 2;10;0;Create;True;0;0;False;0;1,1,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TFHCRemapNode;152;-2439.225,-1114.487;Inherit;False;5;0;FLOAT3;0,0,0;False;1;FLOAT3;-1,-1,-1;False;2;FLOAT3;1,1,1;False;3;FLOAT3;0,0,0;False;4;FLOAT3;1,1,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;144;-2474.521,-937.9849;Float;False;Global;_TrunkWindWeight;_TrunkWindWeight;10;0;Create;True;0;0;False;0;2;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;91;-2793.968,-2025.44;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;102;-2588.873,-2058.04;Inherit;True;Global;_WindVectors;_WindVectors;7;0;Create;True;0;0;False;0;-1;None;0f28b996ff888ec4f9459d2e53004d6f;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;435;-2176.145,-887.8503;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;143;-2049.014,-1089.885;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;380;-3941.727,202.1072;Inherit;False;2300.624;953.9033;Comment;19;386;393;409;405;410;394;403;46;45;383;388;382;397;378;389;381;333;379;390;Color through wind;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;99;-2196.573,-2040.841;Float;False;WindVectors;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;118;-1868.222,-1088.986;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;282;-1708.497,-1084.519;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;379;-3773.349,936.126;Float;False;Property;_Emission_intensity;Emission_intensity;10;0;Create;True;0;0;False;0;1;0.95;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;390;-3902.249,346.7901;Inherit;False;99;WindVectors;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;284;-1792.649,-1821.722;Float;False;Global;_WindStrength;_WindStrength;12;0;Create;True;0;0;False;0;1;0.569;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;333;-3881.977,713.17;Inherit;True;Property;_emit;emit;1;1;[NoScaleOffset];Create;True;0;0;False;0;-1;None;e113935144b2e3941a65f49062e2c135;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;16;-1794.429,-1917.862;Float;False;Property;_MaxWindStrength;MaxWindStrength;5;0;Create;True;0;0;False;0;0.1164738;0.032;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;378;-3451.733,716.5209;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;381;-3663.006,350.4673;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode;283;-1398.063,-1077.496;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-1405.267,-1958.391;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;123;-980.9435,-1585.272;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;45;-3232.81,706.3162;Float;False;SSS;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;10;-985.9244,-1227.753;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;240;-3937.204,1309.256;Inherit;False;1461.06;358.5759;Comment;7;47;50;49;51;108;53;218;AO;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;388;-3170.242,323.9738;Float;False;Property;_Color_variation;Color_variation;6;0;Create;True;0;0;False;0;1;7.49;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;382;-3376.55,352.3343;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;46;-2933.269,538.1703;Inherit;False;45;SSS;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;403;-2889.397,384.9189;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;47;-3887.204,1465.831;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;430;-675.3307,-1505.193;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;241;-3956.704,-349.563;Inherit;False;1209.218;423.3995;Comment;5;105;56;55;31;19;Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;49;-3566.103,1517.832;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;394;-2667.658,385.5151;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;410;-2355.327,575.6615;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexToFragmentNode;331;-420.8947,-1511.448;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;19;-3885.029,-254.8386;Inherit;True;Property;_MainTex;MainTex;0;1;[NoScaleOffset];Create;True;0;0;False;0;-1;None;6c7c48860365bcb43b912371394e9d30;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;50;-3646.703,1374.833;Float;False;Property;_AmbientOcclusion;AmbientOcclusion;4;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;105;-3474.552,-60.52965;Float;False;Constant;_Float3;Float 3;10;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;55;-3229.499,-253.7644;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;405;-2460.187,385.7031;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-3306.103,1472.331;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;17;-103.4811,-1541.025;Float;False;Wind;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;108;-3238.746,1359.257;Float;False;Constant;_Float5;Float 5;10;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;409;-2320.097,544.4003;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;56;-3009.164,-259.9193;Float;False;Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;393;-2203.924,384.3347;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-3548.059,-162.4875;Float;False;Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;53;-3042.204,1412.533;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;18;657.4138,114.166;Inherit;False;17;Wind;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;424;292.7334,331.0477;Float;False;Constant;_Vector0;Vector 0;10;0;Create;True;0;0;False;0;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;423;605.7334,613.0477;Float;False;Property;_FlatLighting;FlatLighting;12;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;428;593.7334,202.0466;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;218;-2757.146,1492.954;Float;False;AmbientOcclusion;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;412;1000.991,106.7823;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;32;653.4365,22.16889;Inherit;False;31;Alpha;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;100;-149.3833,-568.6528;Float;False;Global;_WindDebug;_WindDebug;10;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;-65.0746,-767.5632;Inherit;False;56;Color;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;98;-97.4404,-668.5474;Inherit;False;99;WindVectors;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;386;-1927.052,378.2687;Float;False;emission_color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;425;669.7356,464.9217;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;383;-3209.727,466.476;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;97;267.4849,-572.9194;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;62;208.5449,-366.9655;Inherit;True;Property;_BumpMap;BumpMap;2;1;[NoScaleOffset];Create;True;0;0;False;0;-1;None;9f40df27bdbf97e4eb02ab955f75a486;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;426;276.5376,515.1976;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WireNode;413;1005.794,-98.60233;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;389;-3638.598,481.4377;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;427;958.7324,250.0475;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;217;577.7732,-114.744;Inherit;False;218;AmbientOcclusion;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;411;1052.697,-33.83102;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;254;571.8643,-207.8621;Float;False;Property;_Smoothness;Smoothness;9;0;Create;True;0;0;False;0;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;397;-3408.81,502.4626;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;392;590.567,-297.8044;Inherit;False;386;emission_color;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1157.392,-394.2178;Half;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Playstark/SporeFoliage;False;False;False;False;False;False;True;True;True;True;False;False;True;False;False;False;True;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;False;TreeTransparentCutout;;AlphaTest;All;7;d3d9;d3d11_9x;d3d11;glcore;gles;gles3;metal;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;0;20.3;10;25;True;0.5;True;0;5;False;-1;10;False;-1;0;5;False;-1;10;False;-1;1;False;-1;1;False;-1;0;False;6.8;0.1031574,0.1358041,0.7794118,0;VertexOffset;False;False;Cylindrical;False;Relative;0;;3;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;3;Include;VS_InstancedIndirect.cginc;False;;Custom;Pragma;instancing_options assumeuniformscaling lodfade maxcount:50 procedural:setup forwardadd;False;;Custom;Pragma;multi_compile GPU_FRUSTUM_ON __;False;;Custom;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;415;0;407;0
WireConnection;90;0;59;0
WireConnection;90;1;106;0
WireConnection;250;0;87;1
WireConnection;250;2;87;3
WireConnection;86;0;5;0
WireConnection;194;0;142;0
WireConnection;194;1;168;0
WireConnection;416;0;415;0
WireConnection;60;0;90;0
WireConnection;60;1;4;4
WireConnection;408;0;250;0
WireConnection;408;1;87;2
WireConnection;408;2;416;0
WireConnection;141;0;60;0
WireConnection;141;1;194;0
WireConnection;406;0;86;0
WireConnection;406;1;5;2
WireConnection;406;2;407;0
WireConnection;209;0;406;0
WireConnection;209;1;210;0
WireConnection;249;0;87;1
WireConnection;249;1;87;3
WireConnection;148;0;141;0
WireConnection;148;1;408;0
WireConnection;89;0;60;0
WireConnection;89;1;249;0
WireConnection;150;0;148;0
WireConnection;212;0;211;0
WireConnection;212;1;315;0
WireConnection;212;2;209;0
WireConnection;170;0;154;0
WireConnection;170;1;171;0
WireConnection;152;0;150;0
WireConnection;152;1;170;0
WireConnection;152;2;242;0
WireConnection;152;4;242;0
WireConnection;91;0;212;0
WireConnection;91;1;89;0
WireConnection;102;1;91;0
WireConnection;143;0;152;0
WireConnection;143;1;144;0
WireConnection;99;0;102;0
WireConnection;118;0;143;0
WireConnection;118;1;435;3
WireConnection;282;0;118;0
WireConnection;378;0;333;0
WireConnection;378;1;379;0
WireConnection;381;0;390;0
WireConnection;283;0;282;0
WireConnection;283;2;282;2
WireConnection;15;0;99;0
WireConnection;15;1;16;0
WireConnection;15;2;284;0
WireConnection;123;0;15;0
WireConnection;123;1;283;0
WireConnection;45;0;378;0
WireConnection;382;0;381;0
WireConnection;382;1;381;1
WireConnection;403;0;388;0
WireConnection;403;1;382;0
WireConnection;430;0;283;0
WireConnection;430;1;123;0
WireConnection;430;2;10;2
WireConnection;49;0;47;1
WireConnection;394;0;403;0
WireConnection;394;1;46;0
WireConnection;410;0;46;0
WireConnection;331;0;430;0
WireConnection;55;0;19;0
WireConnection;55;2;105;0
WireConnection;405;0;394;0
WireConnection;51;0;50;0
WireConnection;51;1;49;0
WireConnection;17;0;331;0
WireConnection;409;0;410;0
WireConnection;56;0;55;0
WireConnection;393;0;405;0
WireConnection;393;1;409;0
WireConnection;31;0;19;4
WireConnection;53;0;108;0
WireConnection;53;2;51;0
WireConnection;218;0;53;0
WireConnection;412;0;18;0
WireConnection;386;0;393;0
WireConnection;425;0;424;0
WireConnection;425;1;426;0
WireConnection;383;0;382;0
WireConnection;383;1;397;0
WireConnection;97;0;57;0
WireConnection;97;1;98;0
WireConnection;97;2;100;0
WireConnection;413;0;32;0
WireConnection;427;0;428;0
WireConnection;427;1;424;0
WireConnection;427;2;423;0
WireConnection;411;0;412;0
WireConnection;397;0;389;1
WireConnection;0;0;97;0
WireConnection;0;1;62;0
WireConnection;0;2;392;0
WireConnection;0;4;254;0
WireConnection;0;5;217;0
WireConnection;0;10;413;0
WireConnection;0;11;411;0
WireConnection;0;12;427;0
ASEEND*/
//CHKSM=C902683D39068FEAF97C7E8A5CB89EC4B2FA5582
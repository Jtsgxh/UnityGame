// Upgrade NOTE: upgraded instancing buffer 'PlaystarkStandardDecals' to new syntax.

// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Playstark/StandardDecals"
{
	Properties
	{
		[NoScaleOffset]_ALB("ALB", 2D) = "white" {}
		[NoScaleOffset]_NRM("NRM", 2D) = "bump" {}
		_Opacity("Opacity", Range( 0 , 1)) = 1
		_Smoothness("Smoothness", Range( 0 , 1)) = 1
		_Metallic("Metallic", Range( 0 , 1)) = 1
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_NRMIntensity("NRM Intensity", Range( 0 , 1)) = 0
		_Contrast("Contrast", Range( 0 , 0.499)) = 0
		_Offset("Offset", Range( -1 , 1)) = 0
		_Tiling("Tiling", Float) = 1
		_ALBColor("ALB Color", Color) = (1,1,1,0)
		[Toggle]_PigmentMapColor("PigmentMapColor", Float) = 1
		[Toggle]_VCOn("VC On", Float) = 1
		[Toggle]_InnerShadow("InnerShadow", Float) = 0
		_Wear("Wear", Color) = (0,0,0,0)
		_ContrastWear("ContrastWear", Range( 0 , 0.499)) = 0
		_OffsetWear("OffsetWear", Range( -1 , 1)) = 0
		_Shadow("Shadow", Color) = (0,0,0,0)
		_ContrastShadow("ContrastShadow", Range( 0 , 0.499)) = 0
		_OffsetShadow("OffsetShadow", Range( -1 , 1)) = 0
		[Toggle]_WorldPositionUVOn("WorldPosition UV On", Float) = 0
		_Luminosity("Luminosity", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.5
		#pragma multi_compile_instancing
		#pragma exclude_renderers metal xbox360 xboxone ps4 psp2 n3ds wiiu 
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows nodynlightmap nofog vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float4 vertexColor : COLOR;
		};

		uniform float _NRMIntensity;
		uniform sampler2D _NRM;
		uniform float _WorldPositionUVOn;
		uniform float _Tiling;
		uniform sampler2D _ALB;
		uniform sampler2D _PigmentMap;
		uniform float4 _TerrainUV;
		uniform float _Luminosity;
		uniform float _PigmentMapColor;
		uniform float4 _Shadow;
		uniform float _Offset;
		uniform float _Contrast;
		uniform float _VCOn;
		uniform float _Opacity;
		uniform float _OffsetShadow;
		uniform float _ContrastShadow;
		uniform float4 _Wear;
		uniform float _OffsetWear;
		uniform float _ContrastWear;
		uniform float _InnerShadow;
		uniform float _Metallic;
		uniform float _Smoothness;
		uniform float _Cutoff = 0.5;

		UNITY_INSTANCING_BUFFER_START(PlaystarkStandardDecals)
			UNITY_DEFINE_INSTANCED_PROP(float4, _ALBColor)
#define _ALBColor_arr PlaystarkStandardDecals
		UNITY_INSTANCING_BUFFER_END(PlaystarkStandardDecals)

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			v.normal = float3(0,1,0);
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			half2 temp_cast_0 = (_Tiling).xx;
			float2 uv_TexCoord31 = i.uv_texcoord * temp_cast_0;
			float3 ase_worldPos = i.worldPos;
			half2 appendResult38 = (half2(ase_worldPos.x , ase_worldPos.z));
			o.Normal = UnpackScaleNormal( tex2D( _NRM, (( _WorldPositionUVOn )?( ( appendResult38 * ( _Tiling * 0.1 ) ) ):( uv_TexCoord31 )) ), _NRMIntensity );
			half4 tex2DNode2 = tex2D( _ALB, (( _WorldPositionUVOn )?( ( appendResult38 * ( _Tiling * 0.1 ) ) ):( uv_TexCoord31 )) );
			float4 _ALBColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_ALBColor_arr, _ALBColor);
			half2 appendResult64 = (half2(_TerrainUV.z , _TerrainUV.w));
			float2 TerrainUV71 = ( ( ( 1.0 - appendResult64 ) / _TerrainUV.x ) + ( ( _TerrainUV.x / ( _TerrainUV.x * _TerrainUV.x ) ) * (ase_worldPos).xz ) );
			half4 tex2DNode72 = tex2D( _PigmentMap, TerrainUV71 );
			half4 lerpResult84 = lerp( ( ( tex2DNode72 + tex2DNode72 ) + tex2DNode72 ) , tex2DNode72 , _Luminosity);
			float4 PigmentMapTex73 = lerpResult84;
			half4 lerpResult77 = lerp( _ALBColor_Instance , PigmentMapTex73 , (( _PigmentMapColor )?( 1.0 ):( 0.0 )));
			half4 temp_output_22_0 = ( tex2DNode2 * lerpResult77 );
			half clampResult18 = clamp( ( _Offset + _Contrast ) , 0.0 , 1.0 );
			half clampResult19 = clamp( ( _Offset + ( 1.0 - _Contrast ) ) , 0.0 , 1.0 );
			half clampResult7 = clamp( (0.0 + (tex2DNode2.a - clampResult18) * (1.0 - 0.0) / (clampResult19 - clampResult18)) , 0.0 , 1.0 );
			half lerpResult86 = lerp( 1.0 , 0.0 , i.vertexColor.r);
			half lerpResult34 = lerp( clampResult7 , ( clampResult7 + lerpResult86 ) , (( _VCOn )?( 1.0 ):( 0.0 )));
			half clampResult23 = clamp( ( lerpResult34 * _Opacity ) , 0.0 , 1.0 );
			half lerpResult166 = lerp( 1.0 , 0.0 , clampResult23);
			half clampResult135 = clamp( ( _OffsetShadow + _ContrastShadow ) , 0.0 , 1.0 );
			half clampResult136 = clamp( ( _OffsetShadow + ( 1.0 - _ContrastShadow ) ) , 0.0 , 1.0 );
			half clampResult151 = clamp( (0.0 + (lerpResult166 - clampResult135) * (1.0 - 0.0) / (clampResult136 - clampResult135)) , 0.0 , 1.0 );
			half4 lerpResult110 = lerp( temp_output_22_0 , _Shadow , clampResult151);
			half clampResult160 = clamp( ( _OffsetWear + _ContrastWear ) , 0.0 , 1.0 );
			half clampResult161 = clamp( ( _OffsetWear + ( 1.0 - _ContrastWear ) ) , 0.0 , 1.0 );
			half clampResult163 = clamp( (0.0 + (lerpResult166 - clampResult160) * (1.0 - 0.0) / (clampResult161 - clampResult160)) , 0.0 , 1.0 );
			half4 lerpResult152 = lerp( lerpResult110 , _Wear , clampResult163);
			half4 lerpResult89 = lerp( lerpResult152 , temp_output_22_0 , (( _InnerShadow )?( 0.0 ):( 1.0 )));
			o.Albedo = lerpResult89.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
			clip( clampResult23 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18000
-1566;95;1394;853;1646.959;501.1771;2.748514;True;False
Node;AmplifyShaderEditor.RangedFloatNode;32;-2579.343,-753.6448;Float;False;Property;_Tiling;Tiling;9;0;Create;True;0;0;False;0;1;6.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;37;-2899.135,-631.0873;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-2331.768,-431.5351;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;38;-2610.54,-622.3567;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-2136.576,271.9297;Half;False;Constant;_Float1;Float 1;6;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-2181.646,142.9681;Float;False;Property;_Contrast;Contrast;7;0;Create;True;0;0;False;0;0;0;0;0.499;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-2125.768,-503.7351;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;31;-2261.391,-778.3077;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;14;-2181.649,14.53995;Float;False;Property;_Offset;Offset;8;0;Create;True;0;0;False;0;0;-0.338;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;13;-1845.142,246.2178;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-1662.945,200.279;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-1679.754,20.31848;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;36;-1925.233,-635.2883;Float;False;Property;_WorldPositionUVOn;WorldPosition UV On;20;0;Create;True;0;0;False;0;0;2;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;18;-1510.069,16.91764;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;19;-1536.006,186.2339;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-1482.075,-681.1907;Inherit;True;Property;_ALB;ALB;0;1;[NoScaleOffset];Create;True;0;0;False;0;-1;None;fa7e6811cae7e6744a7255050a3922c9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;28;-1172.943,413.7056;Inherit;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;6;-1046.893,-122.7603;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0.4;False;2;FLOAT;0.6;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;86;-806.9404,480.4654;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;7;-732.5843,-147.6652;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;35;-851.9772,622.2422;Float;False;Property;_VCOn;VC On;12;0;Create;True;0;0;False;0;1;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;45;-3673.906,770.6011;Inherit;False;1616.341;554.3467;Comment;11;71;70;69;68;67;66;65;64;63;62;61;TerrainUV;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector4Node;61;-3644.906,901.9005;Float;False;Global;_TerrainUV;_TerrainUV;2;0;Create;True;0;0;False;0;0,0,0,0;966,966,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;27;-512.0659,5.493279;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;109;-377.3777,343.6373;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;64;-3294.105,821.6013;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;130;-80.22823,1020.977;Half;False;Constant;_Float3;Float 3;6;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;62;-3319.052,1149.093;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-3296.105,1024.601;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-451.352,606.5161;Float;False;Property;_Opacity;Opacity;2;0;Create;True;0;0;False;0;1;0.545;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;129;-125.2983,892.0152;Float;False;Property;_ContrastShadow;ContrastShadow;18;0;Create;True;0;0;False;0;0;0;0;0.499;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;34;-259.1747,-127.766;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;66;-3073.104,972.6014;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;65;-3071.048,1152.093;Inherit;False;FLOAT2;0;2;2;2;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;67;-3110.104,820.6011;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-71.3974,283.7883;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;132;211.2057,995.265;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;131;-125.3012,763.5872;Float;False;Property;_OffsetShadow;OffsetShadow;19;0;Create;True;0;0;False;0;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;23;240.7257,271.8874;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-2804.846,1083.693;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;134;393.4027,949.3261;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;133;376.5936,769.3657;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;69;-2797.104,837.6013;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;136;547.4428,933.5872;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;166;608.5418,1182.802;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;135;546.2786,765.9649;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;70;-2564.341,964.7914;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;71;-2389.497,957.0065;Float;False;TerrainUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;46;-1944.325,781.0699;Inherit;False;1518.383;599.2822;Comment;7;73;84;82;85;81;72;60;Pigment map;1,1,1,1;0;0
Node;AmplifyShaderEditor.TFHCRemapNode;137;765.9045,706.1465;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0.4;False;2;FLOAT;0.6;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;151;1073.902,712.2184;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;60;-1851.758,964.567;Inherit;False;71;TerrainUV;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;143;1242.176,642.4476;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;72;-1576.866,943.3456;Inherit;True;Global;_PigmentMap;_PigmentMap;21;1;[NoScaleOffset];Create;True;0;0;False;0;-1;None;d90450d6b9fe6af408f237f7afa81c67;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;81;-1276,858.454;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;145;1132.258,361.8801;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;85;-1226.598,1206.191;Float;False;Property;_Luminosity;Luminosity;22;0;Create;True;0;0;False;0;0;0.967;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;82;-1089.207,1039.994;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;142;1079.881,50.06859;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;84;-873.53,1037.72;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;154;1.830133,1548.694;Float;False;Property;_ContrastWear;ContrastWear;15;0;Create;True;0;0;False;0;0;0;0;0.499;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;144;957.3372,-49.55784;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;155;46.90019,1677.656;Half;False;Constant;_Float5;Float 5;6;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;156;338.3341,1651.944;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;141;1.062225,-61.52918;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;157;1.827234,1420.266;Float;False;Property;_OffsetWear;OffsetWear;16;0;Create;True;0;0;False;0;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;73;-658.4481,966.695;Float;False;PigmentMapTex;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;21;-791.9293,-806.6981;Float;False;InstancedProperty;_ALBColor;ALB Color;10;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;159;520.5311,1606.005;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;158;503.7221,1426.045;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;78;-833.6484,-539.4183;Float;False;Property;_PigmentMapColor;PigmentMapColor;11;0;Create;True;0;0;False;0;1;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;79;-813.5155,-622.8641;Inherit;False;73;PigmentMapTex;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;111;-1075.889,-823.4904;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;140;-69.4668,-121.6239;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;161;674.571,1590.266;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;160;673.407,1422.644;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;138;-83.56484,-290.4251;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;77;-440.6201,-805.3581;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;24;-971.5319,-865.9154;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-177.1413,-898.6876;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;162;931.4529,1372.431;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0.4;False;2;FLOAT;0.6;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;90;283.6677,-760.2465;Float;False;Property;_Shadow;Shadow;17;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;87;694.2568,-228.0763;Float;False;Property;_InnerShadow;InnerShadow;13;0;Create;True;0;0;False;0;0;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;139;64.92402,-387.1726;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1351.056,245.8471;Float;False;Property;_NRMIntensity;NRM Intensity;6;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;127;1060.943,-265.0541;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;153;254.6178,-389.0972;Float;False;Property;_Wear;Wear;14;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-1044.056,195.8471;Inherit;True;Property;_NRM;NRM;1;1;[NoScaleOffset];Create;True;0;0;False;0;-1;None;0002b32ed12786c44975f699e3c09369;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;122;593.8398,-860.5122;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;163;1201.031,1368.898;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;110;676.6515,-631.3422;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;126;1134.631,-502.6637;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;117;-32.40198,502.6568;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;152;936.4269,-595.4744;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;120;717.5447,-833.4807;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;118;881.9905,422.8495;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;89;1221.283,-683.9626;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;125;1503.018,-441.5311;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;44;1180.361,-89.21093;Float;False;Property;_Metallic;Metallic;4;0;Create;True;0;0;False;0;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;167;1440.106,378.8868;Float;False;Constant;_UpNormalVector1;UpNormalVector;21;0;Create;True;0;0;False;0;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WireNode;148;1268.023,342.6638;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;33;-821.2691,402.7782;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;1160.243,55.23969;Float;False;Property;_Smoothness;Smoothness;3;0;Create;True;0;0;False;0;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;146;1122.214,-139.903;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1698.581,-275.7583;Half;False;True;-1;3;ASEMaterialInspector;0;0;Standard;Playstark/StandardDecals;False;False;False;False;False;False;False;True;False;True;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;7;d3d9;d3d11_9x;d3d11;glcore;gles;gles3;vulkan;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;5;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;42;0;32;0
WireConnection;38;0;37;1
WireConnection;38;1;37;3
WireConnection;40;0;38;0
WireConnection;40;1;42;0
WireConnection;31;0;32;0
WireConnection;13;0;12;0
WireConnection;13;1;10;0
WireConnection;17;0;14;0
WireConnection;17;1;13;0
WireConnection;15;0;14;0
WireConnection;15;1;10;0
WireConnection;36;0;31;0
WireConnection;36;1;40;0
WireConnection;18;0;15;0
WireConnection;19;0;17;0
WireConnection;2;1;36;0
WireConnection;6;0;2;4
WireConnection;6;1;18;0
WireConnection;6;2;19;0
WireConnection;86;2;28;1
WireConnection;7;0;6;0
WireConnection;27;0;7;0
WireConnection;27;1;86;0
WireConnection;109;0;35;0
WireConnection;64;0;61;3
WireConnection;64;1;61;4
WireConnection;63;0;61;1
WireConnection;63;1;61;1
WireConnection;34;0;7;0
WireConnection;34;1;27;0
WireConnection;34;2;109;0
WireConnection;66;0;61;1
WireConnection;66;1;63;0
WireConnection;65;0;62;0
WireConnection;67;0;64;0
WireConnection;3;0;34;0
WireConnection;3;1;4;0
WireConnection;132;0;130;0
WireConnection;132;1;129;0
WireConnection;23;0;3;0
WireConnection;68;0;66;0
WireConnection;68;1;65;0
WireConnection;134;0;131;0
WireConnection;134;1;132;0
WireConnection;133;0;131;0
WireConnection;133;1;129;0
WireConnection;69;0;67;0
WireConnection;69;1;61;1
WireConnection;136;0;134;0
WireConnection;166;2;23;0
WireConnection;135;0;133;0
WireConnection;70;0;69;0
WireConnection;70;1;68;0
WireConnection;71;0;70;0
WireConnection;137;0;166;0
WireConnection;137;1;135;0
WireConnection;137;2;136;0
WireConnection;151;0;137;0
WireConnection;143;0;151;0
WireConnection;72;1;60;0
WireConnection;81;0;72;0
WireConnection;81;1;72;0
WireConnection;145;0;143;0
WireConnection;82;0;81;0
WireConnection;82;1;72;0
WireConnection;142;0;145;0
WireConnection;84;0;82;0
WireConnection;84;1;72;0
WireConnection;84;2;85;0
WireConnection;144;0;142;0
WireConnection;156;0;155;0
WireConnection;156;1;154;0
WireConnection;141;0;144;0
WireConnection;73;0;84;0
WireConnection;159;0;157;0
WireConnection;159;1;156;0
WireConnection;158;0;157;0
WireConnection;158;1;154;0
WireConnection;111;0;2;0
WireConnection;140;0;141;0
WireConnection;161;0;159;0
WireConnection;160;0;158;0
WireConnection;138;0;140;0
WireConnection;77;0;21;0
WireConnection;77;1;79;0
WireConnection;77;2;78;0
WireConnection;24;0;111;0
WireConnection;22;0;24;0
WireConnection;22;1;77;0
WireConnection;162;0;166;0
WireConnection;162;1;160;0
WireConnection;162;2;161;0
WireConnection;139;0;138;0
WireConnection;127;0;87;0
WireConnection;1;1;36;0
WireConnection;1;5;5;0
WireConnection;122;0;22;0
WireConnection;163;0;162;0
WireConnection;110;0;22;0
WireConnection;110;1;90;0
WireConnection;110;2;139;0
WireConnection;126;0;127;0
WireConnection;117;0;1;0
WireConnection;152;0;110;0
WireConnection;152;1;153;0
WireConnection;152;2;163;0
WireConnection;120;0;122;0
WireConnection;118;0;117;0
WireConnection;89;0;152;0
WireConnection;89;1;120;0
WireConnection;89;2;126;0
WireConnection;125;0;89;0
WireConnection;148;0;23;0
WireConnection;33;0;28;1
WireConnection;146;0;118;0
WireConnection;0;0;125;0
WireConnection;0;1;146;0
WireConnection;0;3;44;0
WireConnection;0;4;43;0
WireConnection;0;10;148;0
WireConnection;0;12;167;0
ASEEND*/
//CHKSM=BB910FEC808A1BA1E536F75C70887A312E08A6DF
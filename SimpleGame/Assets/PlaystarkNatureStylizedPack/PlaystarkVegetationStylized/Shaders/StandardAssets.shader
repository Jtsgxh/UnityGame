// Upgrade NOTE: upgraded instancing buffer 'PlaystarkStandardAssets' to new syntax.

// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Playstark/StandardAssets"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_EmissionColor("EmissionColor", Color) = (0,0,0,0)
		[Toggle]_AOasMaskON("AO as Mask ON", Float) = 1
		_ColorMask("Color Mask", Color) = (1,1,1,0)
		_Color1("Color1", Color) = (1,1,1,0)
		[NoScaleOffset]_AlbedoAlpha("Albedo+Alpha", 2D) = "white" {}
		[NoScaleOffset]_Normal("Normal", 2D) = "bump" {}
		[NoScaleOffset]_MetRoughAOEmit("Met+Rough+AO+Emit", 2D) = "white" {}
		_BaseTile("Base Tile", Range( 0 , 10)) = 1
		_METLevel("MET Level", Range( 0 , 1)) = 0
		_RGHLevel("RGH Level", Float) = 1
		_EMILevel("EMI Level", Float) = 1
		_AOLevel("AO Level", Range( 0 , 1)) = 0
		_NRMLevel("NRM Level", Float) = 1
		[Toggle]_AnimatedEmission("Animated Emission", Float) = 0
		[Space(10)][Header(TRIPLANAR DETAIL)][Space(5)][Toggle(_TRIPLANARACTIVE_ON)] _TriplanarActive("TriplanarActive", Float) = 0
		_AlbedoTriplanarBase("Albedo Triplanar Base", 2D) = "white" {}
		_NormalTriplanarBase("Normal Triplanar Base", 2D) = "bump" {}
		_AlbedoTriplanarIntensity("Albedo Triplanar Intensity", Range( 0 , 1)) = 0
		_NRMTriplanarLevel("NRM Triplanar Level", Float) = 1
		_TriplanarTile("Triplanar Tile", Range( 0 , 10)) = 1
		[Space(10)][Header(PANNING EFFECT)][Toggle]_PanningEmission("Panning Emission", Float) = 0
		_EmissionPanningTiling("EmissionPanning Tiling", Float) = 4
		_PanningIntensity("PanningIntensity", Float) = 2
		_PanningOffset("PanningOffset", Range( -1 , 1)) = 0
		_PanningContrast("PanningContrast", Range( 0 , 0.499)) = 0
		[Space(10)][Header(DISSOLVE EFFECT)][Space(5)][Toggle(_DISSOLVEACTIVE_ON)] _DissolveActive("DissolveActive", Float) = 0
		_Speed("Speed", Float) = 0
		_RGHTriplanar("RGH Triplanar", 2D) = "black" {}
		_DISSOLVEAmount("DISSOLVE Amount", Range( 0 , 1)) = 1
		_DissolveNoise("DissolveNoise", 2D) = "white" {}
		_DissolveColor("DissolveColor", Color) = (0,0,0,0)
		_DISSOLVETiling("DISSOLVE Tiling", Float) = 1
		[Space(10)][Header(COVERED)][Space(5)][Toggle(_COVEREDACTIVE_ON)] _CoveredActive("CoveredActive", Float) = 0
		[IntRange]_VCNWMMASK("VC / NWM MASK", Range( 0 , 1)) = 0
		_CoveredTile("Covered Tile", Range( 0 , 10)) = 1
		[IntRange]_CoveredIndex("CoveredIndex", Range( 0 , 12)) = 1
		_CoveredAlbedo("CoveredAlbedo", 2DArray) = "white" {}
		_CoveredNormal("CoveredNormal", 2DArray) = "white" {}
		_CoveredNRMLevel("Covered NRM Level", Float) = 1
		_Offset("Offset", Range( -1 , 1)) = 0
		_Contrast("Contrast", Range( 0 , 0.5)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.0
		#pragma multi_compile_instancing
		#pragma shader_feature _COVEREDACTIVE_ON
		#pragma shader_feature _TRIPLANARACTIVE_ON
		#pragma shader_feature _DISSOLVEACTIVE_ON
		#define ASE_TEXTURE_PARAMS(textureName) textureName

		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			half3 worldNormal;
			INTERNAL_DATA
			float4 vertexColor : COLOR;
			float2 uv2_texcoord2;
		};

		uniform half _NRMLevel;
		uniform sampler2D _Normal;
		uniform half _BaseTile;
		uniform sampler2D _NormalTriplanarBase;
		uniform half _TriplanarTile;
		uniform half _NRMTriplanarLevel;
		uniform UNITY_DECLARE_TEX2DARRAY( _CoveredNormal );
		uniform half _CoveredIndex;
		uniform half _CoveredTile;
		uniform half _CoveredNRMLevel;
		uniform UNITY_DECLARE_TEX2DARRAY( _CoveredAlbedo );
		uniform half _VCNWMMASK;
		uniform half _Offset;
		uniform half _Contrast;
		uniform sampler2D _MetRoughAOEmit;
		uniform half _AOLevel;
		uniform float _AOasMaskON;
		uniform sampler2D _AlbedoAlpha;
		uniform sampler2D _AlbedoTriplanarBase;
		uniform half _AlbedoTriplanarIntensity;
		uniform float _PanningEmission;
		uniform float _AnimatedEmission;
		uniform half _DISSOLVEAmount;
		uniform sampler2D _DissolveNoise;
		uniform half _DISSOLVETiling;
		uniform half4 _DissolveColor;
		uniform half _Speed;
		uniform half _EmissionPanningTiling;
		uniform sampler2D _RGHTriplanar;
		uniform half _PanningOffset;
		uniform half _PanningContrast;
		uniform half _PanningIntensity;
		uniform half _EMILevel;
		uniform float _Cutoff = 0.5;

		UNITY_INSTANCING_BUFFER_START(PlaystarkStandardAssets)
			UNITY_DEFINE_INSTANCED_PROP(float4, _Color1)
#define _Color1_arr PlaystarkStandardAssets
			UNITY_DEFINE_INSTANCED_PROP(float4, _ColorMask)
#define _ColorMask_arr PlaystarkStandardAssets
			UNITY_DEFINE_INSTANCED_PROP(half4, _EmissionColor)
#define _EmissionColor_arr PlaystarkStandardAssets
			UNITY_DEFINE_INSTANCED_PROP(half, _METLevel)
#define _METLevel_arr PlaystarkStandardAssets
			UNITY_DEFINE_INSTANCED_PROP(half, _RGHLevel)
#define _RGHLevel_arr PlaystarkStandardAssets
		UNITY_INSTANCING_BUFFER_END(PlaystarkStandardAssets)


		inline float3 TriplanarSamplingSNF( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			xNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.zy * float2( nsign.x, 1.0 ) ) );
			yNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.xz * float2( nsign.y, 1.0 ) ) );
			zNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.xy * float2( -nsign.z, 1.0 ) ) );
			xNorm.xyz = half3( UnpackScaleNormal( xNorm, normalScale.y ).xy * float2( nsign.x, 1.0 ) + worldNormal.zy, worldNormal.x ).zyx;
			yNorm.xyz = half3( UnpackScaleNormal( yNorm, normalScale.x ).xy * float2( nsign.y, 1.0 ) + worldNormal.xz, worldNormal.y ).xzy;
			zNorm.xyz = half3( UnpackScaleNormal( zNorm, normalScale.y ).xy * float2( -nsign.z, 1.0 ) + worldNormal.xy, worldNormal.z ).xyz;
			return normalize( xNorm.xyz * projNormal.x + yNorm.xyz * projNormal.y + zNorm.xyz * projNormal.z );
		}


		inline float3 TriplanarSamplingSNFA( UNITY_ARGS_TEX2DARRAY( topTexMap ), float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			xNorm = ( UNITY_SAMPLE_TEX2DARRAY( ASE_TEXTURE_PARAMS( topTexMap ), float3( tiling * worldPos.zy * float2( nsign.x, 1.0 ), index.x ) ) );
			yNorm = ( UNITY_SAMPLE_TEX2DARRAY( ASE_TEXTURE_PARAMS( topTexMap ), float3( tiling * worldPos.xz * float2( nsign.y, 1.0 ), index.x ) ) );
			zNorm = ( UNITY_SAMPLE_TEX2DARRAY( ASE_TEXTURE_PARAMS( topTexMap ), float3( tiling * worldPos.xy * float2( -nsign.z, 1.0 ), index.x ) ) );
			xNorm.xyz = half3( UnpackScaleNormal( xNorm, normalScale.y ).xy * float2( nsign.x, 1.0 ) + worldNormal.zy, worldNormal.x ).zyx;
			yNorm.xyz = half3( UnpackScaleNormal( yNorm, normalScale.x ).xy * float2( nsign.y, 1.0 ) + worldNormal.xz, worldNormal.y ).xzy;
			zNorm.xyz = half3( UnpackScaleNormal( zNorm, normalScale.y ).xy * float2( -nsign.z, 1.0 ) + worldNormal.xy, worldNormal.z ).xyz;
			return normalize( xNorm.xyz * projNormal.x + yNorm.xyz * projNormal.y + zNorm.xyz * projNormal.z );
		}


		inline float4 TriplanarSamplingSFA( UNITY_ARGS_TEX2DARRAY( topTexMap ), float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			xNorm = ( UNITY_SAMPLE_TEX2DARRAY( ASE_TEXTURE_PARAMS( topTexMap ), float3( tiling * worldPos.zy * float2( nsign.x, 1.0 ), index.x ) ) );
			yNorm = ( UNITY_SAMPLE_TEX2DARRAY( ASE_TEXTURE_PARAMS( topTexMap ), float3( tiling * worldPos.xz * float2( nsign.y, 1.0 ), index.x ) ) );
			zNorm = ( UNITY_SAMPLE_TEX2DARRAY( ASE_TEXTURE_PARAMS( topTexMap ), float3( tiling * worldPos.xy * float2( -nsign.z, 1.0 ), index.x ) ) );
			return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
		}


		inline float4 TriplanarSamplingSF( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			xNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.zy * float2( nsign.x, 1.0 ) ) );
			yNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.xz * float2( nsign.y, 1.0 ) ) );
			zNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.xy * float2( -nsign.z, 1.0 ) ) );
			return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			half2 temp_cast_0 = (_BaseTile).xx;
			float2 uv_TexCoord488 = i.uv_texcoord * temp_cast_0;
			half2 BaseTile487 = uv_TexCoord488;
			half3 tex2DNode138 = UnpackScaleNormal( tex2D( _Normal, BaseTile487 ), _NRMLevel );
			half2 appendResult4 = (half2(tex2DNode138.r , tex2DNode138.g));
			half3 appendResult40 = (half3(appendResult4 , 1.0));
			half TriplanarTile64 = _TriplanarTile;
			float3 ase_worldPos = i.worldPos;
			half3 ase_worldNormal = WorldNormalVector( i, half3( 0, 0, 1 ) );
			half3 ase_worldTangent = WorldNormalVector( i, half3( 1, 0, 0 ) );
			half3 ase_worldBitangent = WorldNormalVector( i, half3( 0, 1, 0 ) );
			half3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			half4 ase_vertexTangent = mul( unity_WorldToObject, float4( ase_worldTangent, 0 ) );
			half3 ase_vertexBitangent = mul( unity_WorldToObject, float4( ase_worldBitangent, 0 ) );
			half3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			float3x3 objectToTangent = float3x3(ase_vertexTangent.xyz, ase_vertexBitangent, ase_vertexNormal);
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float3 triplanar51 = TriplanarSamplingSNF( _NormalTriplanarBase, ase_vertex3Pos, ase_vertexNormal, 1.0, TriplanarTile64, _NRMTriplanarLevel, 0 );
			float3 tanTriplanarNormal51 = mul( objectToTangent, triplanar51 );
			half2 appendResult52 = (half2(tanTriplanarNormal51.x , tanTriplanarNormal51.y));
			half3 appendResult57 = (half3(appendResult52 , 1.0));
			float3 NRMBase277 = BlendNormals( appendResult40 , appendResult57 );
			#ifdef _TRIPLANARACTIVE_ON
				float3 staticSwitch372 = NRMBase277;
			#else
				float3 staticSwitch372 = appendResult40;
			#endif
			half Index288 = _CoveredIndex;
			half CoveredTile434 = _CoveredTile;
			float3 triplanar276 = TriplanarSamplingSNFA( UNITY_PASS_TEX2DARRAY(_CoveredNormal), ase_vertex3Pos, ase_vertexNormal, 1.0, CoveredTile434, _CoveredNRMLevel, Index288 );
			float3 tanTriplanarNormal276 = mul( objectToTangent, triplanar276 );
			float4 triplanar283 = TriplanarSamplingSFA( UNITY_PASS_TEX2DARRAY(_CoveredAlbedo), ase_vertex3Pos, ase_vertexNormal, 1.0, CoveredTile434, 1.0, Index288 );
			float CovAlb308 = triplanar283.w;
			float VertexRed120 = i.vertexColor.r;
			half lerpResult492 = lerp( ( CovAlb308 * ( 1.0 - VertexRed120 ) ) , (WorldNormalVector( i , UnpackNormal( tex2D( _Normal, BaseTile487 ) ) )).y , _VCNWMMASK);
			half clampResult318 = clamp( ( _Offset + _Contrast ) , 0.0 , 1.0 );
			half clampResult317 = clamp( ( _Offset + ( 1.0 - _Contrast ) ) , 0.0 , 1.0 );
			half clampResult322 = clamp( (0.0 + (lerpResult492 - clampResult318) * (1.0 - 0.0) / (clampResult317 - clampResult318)) , 0.0 , 1.0 );
			float Covered_mask270 = clampResult322;
			half3 lerpResult272 = lerp( staticSwitch372 , tanTriplanarNormal276 , Covered_mask270);
			#ifdef _COVEREDACTIVE_ON
				float3 staticSwitch410 = lerpResult272;
			#else
				float3 staticSwitch410 = staticSwitch372;
			#endif
			float3 nrm9 = staticSwitch410;
			o.Normal = nrm9;
			float4 _Color1_Instance = UNITY_ACCESS_INSTANCED_PROP(_Color1_arr, _Color1);
			half4 tex2DNode139 = tex2D( _MetRoughAOEmit, BaseTile487 );
			half lerpResult255 = lerp( (float)1 , tex2DNode139.b , _AOLevel);
			float ao6 = lerpResult255;
			int AOasmaskON186 = (( _AOasMaskON )?( 1 ):( 0 ));
			half4 lerpResult192 = lerp( _Color1_Instance , ( _Color1_Instance + ao6 ) , (float)AOasmaskON186);
			half4 tex2DNode137 = tex2D( _AlbedoAlpha, BaseTile487 );
			half3 appendResult20 = (half3(tex2DNode137.r , tex2DNode137.g , tex2DNode137.b));
			float4 triplanar26 = TriplanarSamplingSF( _AlbedoTriplanarBase, ase_vertex3Pos, ase_vertexNormal, 1.0, TriplanarTile64, 1.0, 0 );
			half4 blendOpSrc342 = triplanar26;
			half4 blendOpDest342 = tex2DNode137;
			half4 lerpResult146 = lerp( tex2DNode137 , ( saturate( (( blendOpDest342 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest342 ) * ( 1.0 - blendOpSrc342 ) ) : ( 2.0 * blendOpDest342 * blendOpSrc342 ) ) )) , _AlbedoTriplanarIntensity);
			#ifdef _TRIPLANARACTIVE_ON
				float4 staticSwitch368 = lerpResult146;
			#else
				float4 staticSwitch368 = float4( appendResult20 , 0.0 );
			#endif
			half4 temp_output_151_0 = ( lerpResult192 * staticSwitch368 );
			float4 _ColorMask_Instance = UNITY_ACCESS_INSTANCED_PROP(_ColorMask_arr, _ColorMask);
			half4 lerpResult171 = lerp( temp_output_151_0 , ( temp_output_151_0 * _ColorMask_Instance ) , ao6);
			half4 lerpResult189 = lerp( temp_output_151_0 , lerpResult171 , (float)AOasmaskON186);
			half4 lerpResult281 = lerp( lerpResult189 , triplanar283 , Covered_mask270);
			#ifdef _COVEREDACTIVE_ON
				float4 staticSwitch384 = lerpResult281;
			#else
				float4 staticSwitch384 = lerpResult189;
			#endif
			float4 albedo10 = staticSwitch384;
			half4 clampResult462 = clamp( albedo10 , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			o.Albedo = clampResult462.rgb;
			half clampResult141 = clamp( tex2DNode139.a , 0.0 , 1.0 );
			half4 _EmissionColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_EmissionColor_arr, _EmissionColor);
			float4 emit5 = ( clampResult141 * _EmissionColor_Instance );
			half clampResult461 = clamp( (0.15 + (_SinTime.w - 1.0) * (1.0 - 0.15) / (-1.0 - 1.0)) , 0.0 , 1.0 );
			half2 temp_cast_9 = (_DISSOLVETiling).xx;
			float2 uv2_TexCoord203 = i.uv2_texcoord2 * temp_cast_9;
			half clampResult439 = clamp( tex2D( _DissolveNoise, uv2_TexCoord203 ).r , 0.0 , 1.0 );
			half clampResult210 = clamp( ( ( (-1.5 + (_DISSOLVEAmount - 0.0) * (1.0 - -1.5) / (1.0 - 0.0)) + ( 1.0 - i.vertexColor.b ) ) + clampResult439 ) , 0.0 , 1.0 );
			float Cutout211 = clampResult210;
			half clampResult216 = clamp( (-2.0 + (Cutout211 - 0.0) * (2.0 - -2.0) / (1.0 - 0.0)) , 0.0 , 1.0 );
			half clampResult218 = clamp( ( 1.0 - clampResult216 ) , 0.0 , 1.0 );
			float4 Dissolve219 = ( clampResult218 * _DissolveColor );
			#ifdef _DISSOLVEACTIVE_ON
				float4 staticSwitch409 = ( (( _AnimatedEmission )?( ( emit5 * clampResult461 ) ):( emit5 )) + Dissolve219 );
			#else
				float4 staticSwitch409 = (( _AnimatedEmission )?( ( emit5 * clampResult461 ) ):( emit5 ));
			#endif
			float4 SpeedTime394 = ( _Time * 1.0 );
			float SpeedIntensity395 = _Speed;
			half2 temp_cast_11 = (SpeedIntensity395).xx;
			float PanningTile390 = _EmissionPanningTiling;
			half2 temp_cast_12 = (PanningTile390).xx;
			float2 uv_TexCoord398 = i.uv_texcoord * temp_cast_12;
			half2 panner400 = ( SpeedTime394.x * temp_cast_11 + uv_TexCoord398);
			float4 triplanar68 = TriplanarSamplingSF( _RGHTriplanar, ase_vertex3Pos, ase_vertexNormal, 1.0, TriplanarTile64, 1.0, 0 );
			half clampResult423 = clamp( ( _PanningOffset + _PanningContrast ) , 0.0 , 1.0 );
			half clampResult422 = clamp( ( _PanningOffset + ( 1.0 - _PanningContrast ) ) , 0.0 , 1.0 );
			half clampResult425 = clamp( (0.0 + (( tex2D( _DissolveNoise, panner400 ).r * triplanar68.w * VertexRed120 ) - clampResult423) * (1.0 - 0.0) / (clampResult422 - clampResult423)) , 0.0 , 1.0 );
			half temp_output_407_0 = ( clampResult425 * _PanningIntensity );
			float4 PanningEmission408 = ( temp_output_407_0 * _EmissionColor_Instance );
			o.Emission = ( (( _PanningEmission )?( ( staticSwitch409 + PanningEmission408 ) ):( staticSwitch409 )) * _EMILevel ).rgb;
			half _METLevel_Instance = UNITY_ACCESS_INSTANCED_PROP(_METLevel_arr, _METLevel);
			float metal8 = ( _METLevel_Instance * tex2DNode139.r );
			o.Metallic = metal8;
			half _RGHLevel_Instance = UNITY_ACCESS_INSTANCED_PROP(_RGHLevel_arr, _RGHLevel);
			float rough7 = ( _RGHLevel_Instance * tex2DNode139.g );
			o.Smoothness = rough7;
			half lerpResult187 = lerp( ao6 , (float)1 , (float)AOasmaskON186);
			o.Occlusion = lerpResult187;
			o.Alpha = 1;
			#ifdef _DISSOLVEACTIVE_ON
				float staticSwitch374 = Cutout211;
			#else
				float staticSwitch374 = (float)1;
			#endif
			clip( staticSwitch374 - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma exclude_renderers xbox360 xboxone ps4 psp2 n3ds wiiu 
		#pragma surface surf Standard keepalpha fullforwardshadows nodynlightmap nofog dithercrossfade 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				half4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.customPack1.zw = customInputData.uv2_texcoord2;
				o.customPack1.zw = v.texcoord1;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				surfIN.uv2_texcoord2 = IN.customPack1.zw;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.vertexColor = IN.color;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18000
-1566;113;1394;835;4048.393;-3614.213;3.482049;True;False
Node;AmplifyShaderEditor.CommentaryNode;198;-2973.023,3499.098;Inherit;False;2804.625;1209.398;Dissolve - Opacity Mask;12;441;440;439;206;201;211;210;207;238;203;202;200;DISSOLVE;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;135;-3080.48,-3156.973;Inherit;False;1289.281;1029.161;;17;434;433;64;41;18;58;118;119;288;115;289;59;120;17;486;487;488;CONTROLS;0.5588235,0.9634888,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;486;-2870.776,-2827.171;Half;False;Property;_BaseTile;Base Tile;8;0;Create;True;0;0;False;0;1;0.14;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;200;-2806.471,4423.048;Half;False;Property;_DISSOLVETiling;DISSOLVE Tiling;32;0;Create;True;0;0;False;0;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;488;-2486.67,-2824.863;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;202;-2839.368,3744.352;Half;False;Property;_DISSOLVEAmount;DISSOLVE Amount;29;0;Create;True;0;0;False;0;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;201;-2471.231,3985.629;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;203;-2595.682,4410.961;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;238;-2340.544,4374.739;Inherit;True;Property;_DissolveNoise;DissolveNoise;30;0;Create;True;0;0;False;0;-1;None;d9a770fddc0276740b642075488dc8ac;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;433;-2870.732,-2910.484;Half;False;Property;_CoveredTile;Covered Tile;35;0;Create;True;0;0;False;0;1;0.14;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;206;-2292.509,3753.818;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1.5;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;441;-2196.864,4015.766;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-2874.308,-3009.602;Half;False;Property;_TriplanarTile;Triplanar Tile;20;0;Create;True;0;0;False;0;1;0.2;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;487;-2213.776,-2830.171;Half;False;BaseTile;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;134;-3009.318,1186.302;Inherit;False;2684.107;1088.163;;16;7;8;32;34;35;33;5;247;248;141;6;255;139;36;465;491;METAL + ROUGH + AO + EMIT;0.7132353,1,0.7152129,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;289;-2872.853,-3108.105;Half;False;Property;_CoveredIndex;CoveredIndex;36;1;[IntRange];Create;True;0;0;False;0;1;7;0;12;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;132;-3054.144,-1886.893;Inherit;False;5480.592;1666.12;;36;149;192;174;191;173;170;172;171;282;10;137;281;20;303;287;189;169;151;308;283;284;146;145;330;342;65;26;368;373;384;180;186;435;468;469;489;ALBEDO;1,0.7058823,0.7058823,1;0;0
Node;AmplifyShaderEditor.ClampOpNode;439;-1996.844,4401.627;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;440;-1982.191,3752.56;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;386;-49.55425,-23.53655;Inherit;False;1403.942;726.2545;;8;395;394;393;391;390;389;388;387;Animation + Variables;1,0.9900609,0.6397059,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;434;-2486.333,-2911.981;Half;False;CoveredTile;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;288;-2479.853,-3108.105;Half;False;Index;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;64;-2492.348,-3006.696;Half;False;TriplanarTile;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;491;-2980.956,1298.364;Inherit;False;487;BaseTile;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;489;-2931.152,-1434.684;Inherit;False;487;BaseTile;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;287;-197.5243,-503.7441;Inherit;False;288;Index;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;387;113.4077,117.108;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;389;45.96189,302.4615;Half;False;Constant;_SpeedTime;Speed Time;12;0;Create;True;0;0;False;0;1;1;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;284;-225.4618,-398.3286;Inherit;False;434;CoveredTile;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;65;-2852.373,-777.9303;Inherit;False;64;TriplanarTile;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;139;-2754.766,1277.341;Inherit;True;Property;_MetRoughAOEmit;Met+Rough+AO+Emit;7;1;[NoScaleOffset];Create;True;0;0;False;0;-1;None;5aff7b66444242847a0aff88dfc14794;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;17;-2982.567,-2458.254;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IntNode;465;-1475.277,1427.376;Inherit;False;Constant;_Int0;Int 0;39;0;Create;True;0;0;False;0;1;0;0;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-1617.894,1538.935;Half;False;Property;_AOLevel;AO Level;12;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;303;-328.334,-702.9339;Float;True;Property;_CoveredAlbedo;CoveredAlbedo;37;0;Create;True;0;0;False;0;None;9c13493d23556284b94cdc86bab2273c;False;white;Auto;Texture2DArray;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;388;37.5258,540.123;Half;False;Property;_EmissionPanningTiling;EmissionPanning Tiling;22;0;Create;True;0;0;False;0;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;207;-1674.948,3751.749;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;257;-2941.997,5016.753;Inherit;False;1130.989;425.5272;COVERED VERTEX COLOR MASK;4;266;265;309;263;COVERED VERTEX COLOR MASK;1,1,1,1;0;0
Node;AmplifyShaderEditor.IntNode;469;411.2498,-693.1519;Inherit;False;Constant;_Int4;Int 4;45;0;Create;True;0;0;False;0;1;0;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;468;411.2499,-787.8044;Inherit;False;Constant;_Int3;Int 3;45;0;Create;True;0;0;False;0;0;0;0;1;INT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;120;-2168.646,-2566.641;Float;False;VertexRed;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;210;-1368.553,3752.26;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;392;170.2549,1178.466;Inherit;False;3451.919;1100.808;;26;417;419;425;424;423;422;421;420;418;416;408;407;406;405;68;67;401;400;397;399;398;396;426;431;414;415;EMISSION ANIMATION;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;470;-2927.926,5684.847;Inherit;False;1142.25;516.0505;COVERED WORLD NORMAL MASK;3;474;473;494;COVERED WORLD NORMAL MASK;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;391;402.8135,224.1385;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;393;42.67088,423.2194;Half;False;Property;_Speed;Speed;27;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;26;-2592.629,-829.4666;Inherit;True;Spherical;Object;False;Albedo Triplanar Base;_AlbedoTriplanarBase;white;16;None;Mid Texture 0;_MidTexture0;white;-1;None;Bot Texture 0;_BotTexture0;white;-1;None;Albedo Triplanar Base;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;255;-1295.822,1451.485;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;283;169.1875,-560.759;Inherit;True;Spherical;Object;False;CoveredALB;_CoveredALB;white;37;None;Mid Texture 4;_MidTexture4;white;-1;None;Bot Texture 4;_BotTexture4;white;-1;None;CoveredAlbedoTriplanar;True;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;137;-2687,-1457.117;Inherit;True;Property;_AlbedoAlpha;Albedo+Alpha;5;1;[NoScaleOffset];Create;True;0;0;False;0;-1;None;1f049aa3dbb7d85409a365bc0a2ce974;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;390;515.3306,546.051;Float;False;PanningTile;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;311;-1208.563,5817.206;Half;False;Constant;_Float6;Float 6;6;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;396;184.1793,1319.178;Inherit;False;390;PanningTile;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;263;-2817.571,5239.018;Inherit;False;120;VertexRed;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;330;-2132.236,-1068.408;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;211;-1089.209,3745.874;Float;True;Cutout;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;145;-2143.534,-538.4004;Half;False;Property;_AlbedoTriplanarIntensity;Albedo Triplanar Intensity;18;0;Create;True;0;0;False;0;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;199;-3000.99,2701.096;Inherit;False;2345.054;555.1095;Burn Effect - Emission;10;219;240;218;239;217;216;215;212;214;213;BURN EFFECT;1,0.6102941,0.6102941,1;0;0
Node;AmplifyShaderEditor.ToggleSwitchNode;180;640.6747,-785.753;Float;False;Property;_AOasMaskON;AO as Mask ON;2;0;Create;True;0;0;False;0;1;2;0;INT;0;False;1;INT;0;False;1;INT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;395;511.6445,422.7905;Float;False;SpeedIntensity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;394;605.5815,234.0114;Float;False;SpeedTime;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;308;723.4868,-468.0806;Float;True;CovAlb;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;6;-617.2263,1468.592;Float;True;ao;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;312;-1236.324,5595.3;Half;False;Property;_Contrast;Contrast;41;0;Create;True;0;0;False;0;0;0.48;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;494;-2884.082,5923.619;Inherit;False;487;BaseTile;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BlendOpsNode;342;-2130.033,-837.1453;Inherit;True;Overlay;True;3;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;314;-1241.781,5453.803;Half;False;Property;_Offset;Offset;40;0;Create;True;0;0;False;0;0;-0.15;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;146;-1652.208,-857.5037;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;473;-2606.942,5905.712;Inherit;True;Property;_TextureSample2;Texture Sample 2;6;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;True;Instance;138;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;186;897.1649,-785.6031;Float;False;AOasmaskON;-1;True;1;0;INT;0;False;1;INT;0
Node;AmplifyShaderEditor.GetLocalVarNode;309;-2809.675,5135.299;Inherit;False;308;CovAlb;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;399;438.1844,1615.42;Inherit;False;394;SpeedTime;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.OneMinusNode;265;-2605.144,5244.385;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;313;-1018.949,5819.339;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;398;407.3332,1300.564;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;397;404.5075,1507.439;Inherit;False;395;SpeedIntensity;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;417;1145.348,1879.438;Half;False;Property;_PanningContrast;PanningContrast;25;0;Create;True;0;0;False;0;0;0.247;0;0.499;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;214;-2951.293,3043.96;Half;False;Constant;_DISSOLVERemapMax;DISSOLVE Remap Max;13;0;Create;True;0;0;False;0;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;213;-2925.316,2811.281;Inherit;False;211;Cutout;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;212;-2949.219,2937.457;Half;False;Constant;_DISSOLVERemapMin;DISSOLVE Remap Min;12;0;Create;True;0;0;False;0;-2;-2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;416;1177.109,2099.344;Half;False;Constant;_Float5;Float 5;6;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;173;-1202.51,-1602.924;Inherit;False;6;ao;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;133;-3036.039,-27.8539;Inherit;False;2863.374;1007.655;;22;9;272;290;304;278;372;276;285;279;277;56;40;57;4;52;138;51;31;66;53;410;490;NORMAL;0.6029412,0.6056795,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;149;-1272.878,-1830.597;Float;False;InstancedProperty;_Color1;Color1;4;0;Create;True;0;0;False;0;1,1,1,0;0.8,0.704,0.704,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;67;245.0917,1889.035;Inherit;False;64;TriplanarTile;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;419;1143.891,1735.941;Half;False;Property;_PanningOffset;PanningOffset;24;0;Create;True;0;0;False;0;0;0.09;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;215;-2678.82,2872.884;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-4;False;4;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-2940.068,210.6628;Half;False;Property;_NRMLevel;NRM Level;13;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;400;689.2967,1300.504;Inherit;True;3;0;FLOAT2;0.2,0.2;False;2;FLOAT2;0,0.2;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;316;-816.6175,5501.077;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;174;-930.002,-1708.709;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;418;1366.723,2101.478;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;20;-2121.985,-1432.697;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;191;-1019.793,-1502.072;Inherit;False;186;AOasmaskON;1;0;OBJECT;0;False;1;INT;0
Node;AmplifyShaderEditor.WorldNormalVector;474;-2235.169,5912.017;Inherit;True;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WireNode;373;-737.3005,-946.9867;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;315;-836.7524,5773.399;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;266;-2341.014,5123.451;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;496;-1988.073,6316.687;Half;False;Property;_VCNWMMASK;VC / NWM MASK;34;1;[IntRange];Create;True;0;0;False;0;0;0.48;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-2983.979,436.8368;Half;False;Property;_NRMTriplanarLevel;NRM Triplanar Level;19;0;Create;True;0;0;False;0;1;1.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;66;-2976.214,545.7466;Inherit;False;64;TriplanarTile;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;490;-2938.387,98.70186;Inherit;False;487;BaseTile;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;248;-1457.84,1631.456;Half;False;InstancedProperty;_EmissionColor;EmissionColor;1;0;Create;True;0;0;False;0;0,0,0,0;0,0.7591829,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;421;1548.92,2055.539;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;51;-2722.93,415.2746;Inherit;True;Spherical;Object;True;Normal Triplanar Base;_NormalTriplanarBase;bump;17;None;Mid Texture 1;_MidTexture1;white;-1;None;Bot Texture 1;_BotTexture1;white;-1;None;Normal Triplanar Base;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;138;-2616.384,81.45165;Inherit;True;Property;_Normal;Normal;6;1;[NoScaleOffset];Create;True;0;0;False;0;-1;None;edc97b398f27cb04aad4d33c3e91cedc;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;216;-2361.415,2776.527;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;192;-695.4753,-1818.117;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;141;-1675.28,1778.34;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;426;1090.071,1616.476;Inherit;False;120;VertexRed;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;368;-418.1375,-1416.229;Float;False;Property;_TriplanarActive;TriplanarActive;15;0;Create;True;0;0;False;3;Space(10);Header(TRIPLANAR DETAIL);Space(5);0;0;0;True;;Toggle;2;Key0;Key1;Create;False;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;401;977.866,1321.433;Inherit;True;Property;_TextureSample0;Texture Sample 0;30;1;[NoScaleOffset];Create;True;0;0;False;0;-1;None;1746d72c8cbcebf4ebe6ab93898e2f61;True;0;False;white;Auto;False;Instance;238;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;420;1579.647,1736.735;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;68;483.5168,1849.664;Inherit;True;Spherical;Object;False;RGH Triplanar;_RGHTriplanar;black;28;None;Mid Texture 2;_MidTexture2;white;-1;None;Bot Texture 2;_BotTexture2;white;-1;None;RGH Triplanar;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;136;2762.235,-1882.991;Inherit;False;3166.694;1999.274;;29;0;13;443;335;374;14;187;375;12;235;11;15;188;38;411;412;242;413;409;337;377;341;226;221;334;461;462;463;466;SHADER;1,1,1,1;0;0
Node;AmplifyShaderEditor.ClampOpNode;317;-676.8558,5747.891;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;318;-646.9327,5497.674;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;492;-1439.411,5129.752;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;422;1708.818,2030.029;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;4;-2267.171,110.819;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;405;1413.343,1338.088;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;151;89.15208,-1436.151;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;170;205.6884,-1109.501;Float;False;InstancedProperty;_ColorMask;Color Mask;3;0;Create;True;0;0;False;0;1,1,1,0;0.7169812,0.4014067,0.3821643,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinTimeNode;334;2793.129,-1398.829;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;247;-1118.803,1777.788;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;423;1749.332,1736.983;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;52;-2262.71,432.676;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;217;-2145.07,2774.739;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;319;-366.0264,5485.049;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0.4;False;2;FLOAT;0.6;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;172;511.555,-1021.152;Inherit;True;6;ao;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;40;-1989.483,110.9641;Inherit;True;FLOAT3;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;5;-632.6122,1780.224;Float;True;emit;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;424;1990.523,1658.396;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0.4;False;2;FLOAT;0.6;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;218;-1906.925,2771.627;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;169;509.6541,-1164.939;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;239;-1785.941,2990.791;Half;False;Property;_DissolveColor;DissolveColor;31;0;Create;True;0;0;False;0;0,0,0,0;0,0.8842337,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;57;-1989.461,432.6087;Inherit;True;FLOAT3;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;322;-88.89127,5481.254;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;341;2966.918,-1328.609;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;-1;False;3;FLOAT;0.15;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;56;-1740.378,414.0291;Inherit;True;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;461;3252.893,-1331.384;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;425;2288.239,1408.12;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;226;3120.713,-1618.557;Inherit;True;5;emit;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;406;2201.547,2020.634;Half;False;Property;_PanningIntensity;PanningIntensity;23;0;Create;True;0;0;False;0;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;240;-1466.234,2791.694;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;270;67.19665,5474.44;Float;True;Covered_mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;171;884.1065,-1198.95;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;279;-2039.432,799.1168;Half;False;Property;_CoveredNRMLevel;Covered NRM Level;39;0;Create;True;0;0;False;0;1;7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;219;-1003.295,2786;Float;True;Dissolve;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;242;3420.933,-1451.341;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;290;-1990.497,680.8559;Inherit;False;288;Index;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;189;1231.552,-1418.842;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;277;-1450.198,406.187;Float;False;NRMBase;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;285;-2019.809,887.3578;Inherit;False;434;CoveredTile;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;304;-2531.018,739.6529;Float;True;Property;_CoveredNormal;CoveredNormal;38;0;Create;True;0;0;False;0;None;9442314057dead14495529513d77fbc1;False;white;Auto;Texture2DArray;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.WireNode;435;1071.097,-643.9722;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;282;1046.652,-455.7755;Inherit;False;270;Covered_mask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;407;2532.308,1406.724;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;278;-1258.669,834.0901;Inherit;False;270;Covered_mask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;431;2943.781,1639.134;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;281;1444.31,-977.735;Inherit;True;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;221;3710.769,-1224.105;Inherit;False;219;Dissolve;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;337;3658.016,-1651.961;Float;True;Property;_AnimatedEmission;Animated Emission;14;0;Create;True;0;0;False;1;;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TriplanarNode;276;-1683.56,739.8613;Inherit;True;Spherical;Object;True;CoveredNRM;_CoveredNRM;white;36;None;Mid Texture 3;_MidTexture3;white;-1;None;Bot Texture 3;_BotTexture3;white;-1;None;Covered normal;True;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;372;-1210.463,123.7007;Float;False;Property;_TriplanarActive;TriplanarActive;15;0;Create;True;0;0;False;0;0;0;0;False;;Toggle;2;Key0;Key1;Reference;368;False;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;408;3274.841,1638.3;Float;True;PanningEmission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;272;-873.6489,225.3189;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;377;3941.333,-1467.115;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;384;1693.753,-1232.809;Float;False;Property;_CoveredActive;CoveredActive;33;0;Create;True;0;0;False;3;Space(10);Header(COVERED);Space(5);0;0;0;True;;Toggle;2;Key0;Key1;Create;False;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;10;2070.571,-1235.986;Float;True;albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;413;4077.783,-1305.359;Inherit;False;408;PanningEmission;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-1479.283,1336.475;Half;False;InstancedProperty;_RGHLevel;RGH Level;10;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-1600.643,1236.371;Half;False;InstancedProperty;_METLevel;MET Level;9;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;410;-670.4954,123.9004;Float;False;Property;_CoveredActive;CoveredActive;33;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Reference;384;False;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;409;4060.816,-1655.892;Float;False;Property;_DissolveActive;DissolveActive;26;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Reference;374;False;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-1289.741,1247.703;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;11;3379.442,-1834.754;Inherit;True;10;albedo;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;9;-370.7842,124.4603;Float;False;nrm;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-1291.713,1344.776;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;412;4378.365,-1485.332;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;235;4359.379,-278.7653;Inherit;False;211;Cutout;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;12;4325.412,-1727.282;Inherit;False;9;nrm;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.IntNode;375;4386.919,-369.1107;Inherit;False;Constant;_Int1;Int 1;39;0;Create;True;0;0;False;0;1;0;0;1;INT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;411;4537.887,-1640.334;Float;True;Property;_PanningEmission;Panning Emission;21;0;Create;True;0;0;False;2;Space(10);Header(PANNING EFFECT);0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.IntNode;466;4392.22,-613.6577;Inherit;False;Constant;_Int2;Int 2;39;0;Create;True;0;0;False;0;1;0;0;1;INT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;7;-642.8942,1358.39;Float;False;rough;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;8;-644.6339,1246.414;Float;False;metal;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;188;4354.515,-524.8752;Inherit;False;186;AOasmaskON;1;0;OBJECT;0;False;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;4581.091,-1347.618;Half;False;Property;_EMILevel;EMI Level;11;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;462;3666.006,-1829.009;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;15;4357.716,-695.5873;Inherit;False;6;ao;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;187;4724.951,-684.0177;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;14;4690.334,-824.7888;Inherit;False;7;rough;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;119;-2359.646,-2430.641;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;255;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;59;-2163.352,-2300.187;Float;False;VertexAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;443;4578.93,-1700.131;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;13;4687.621,-930.7036;Inherit;False;8;metal;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;463;4553.801,-1782.688;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;374;4657.001,-383.6983;Float;False;Property;_DissolveActive;DissolveActive;26;0;Create;True;0;0;False;3;Space(10);Header(DISSOLVE EFFECT);Space(5);0;0;0;True;;Toggle;2;Key0;Key1;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;118;-2164.646,-2441.641;Float;False;VertexBlue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;115;-2351.127,-2295.547;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;255;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;18;-2675.668,-2623.157;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;414;2863.998,1257.55;Inherit;True;Property;_TextureSample1;Texture Sample 1;8;1;[NoScaleOffset];Create;True;0;0;False;0;-1;0c1654a137d7df741b6e1a143703a9a8;00d8782ec19e47e48a81879beed7dff4;True;0;False;black;Auto;False;Instance;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;58;-2505.081,-2629.188;Float;False;VertexRGB;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;335;4928.81,-1639.987;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;415;3185.645,1280.078;Inherit;True;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;5223.206,-1733.275;Half;False;True;-1;4;ASEMaterialInspector;0;0;Standard;Playstark/StandardAssets;False;False;False;False;False;False;False;True;False;True;False;False;True;False;False;False;True;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Geometry;All;8;d3d9;d3d11_9x;d3d11;glcore;gles;gles3;metal;vulkan;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;488;0;486;0
WireConnection;203;0;200;0
WireConnection;238;1;203;0
WireConnection;206;0;202;0
WireConnection;441;0;201;3
WireConnection;487;0;488;0
WireConnection;439;0;238;1
WireConnection;440;0;206;0
WireConnection;440;1;441;0
WireConnection;434;0;433;0
WireConnection;288;0;289;0
WireConnection;64;0;41;0
WireConnection;139;1;491;0
WireConnection;207;0;440;0
WireConnection;207;1;439;0
WireConnection;120;0;17;1
WireConnection;210;0;207;0
WireConnection;391;0;387;0
WireConnection;391;1;389;0
WireConnection;26;3;65;0
WireConnection;255;0;465;0
WireConnection;255;1;139;3
WireConnection;255;2;36;0
WireConnection;283;0;303;0
WireConnection;283;5;287;0
WireConnection;283;3;284;0
WireConnection;137;1;489;0
WireConnection;390;0;388;0
WireConnection;330;0;137;0
WireConnection;211;0;210;0
WireConnection;180;0;468;0
WireConnection;180;1;469;0
WireConnection;395;0;393;0
WireConnection;394;0;391;0
WireConnection;308;0;283;4
WireConnection;6;0;255;0
WireConnection;342;0;26;0
WireConnection;342;1;137;0
WireConnection;146;0;330;0
WireConnection;146;1;342;0
WireConnection;146;2;145;0
WireConnection;473;1;494;0
WireConnection;186;0;180;0
WireConnection;265;0;263;0
WireConnection;313;0;311;0
WireConnection;313;1;312;0
WireConnection;398;0;396;0
WireConnection;215;0;213;0
WireConnection;215;3;212;0
WireConnection;215;4;214;0
WireConnection;400;0;398;0
WireConnection;400;2;397;0
WireConnection;400;1;399;0
WireConnection;316;0;314;0
WireConnection;316;1;312;0
WireConnection;174;0;149;0
WireConnection;174;1;173;0
WireConnection;418;0;416;0
WireConnection;418;1;417;0
WireConnection;20;0;137;1
WireConnection;20;1;137;2
WireConnection;20;2;137;3
WireConnection;474;0;473;0
WireConnection;373;0;146;0
WireConnection;315;0;314;0
WireConnection;315;1;313;0
WireConnection;266;0;309;0
WireConnection;266;1;265;0
WireConnection;421;0;419;0
WireConnection;421;1;418;0
WireConnection;51;8;53;0
WireConnection;51;3;66;0
WireConnection;138;1;490;0
WireConnection;138;5;31;0
WireConnection;216;0;215;0
WireConnection;192;0;149;0
WireConnection;192;1;174;0
WireConnection;192;2;191;0
WireConnection;141;0;139;4
WireConnection;368;1;20;0
WireConnection;368;0;373;0
WireConnection;401;1;400;0
WireConnection;420;0;419;0
WireConnection;420;1;417;0
WireConnection;68;3;67;0
WireConnection;317;0;315;0
WireConnection;318;0;316;0
WireConnection;492;0;266;0
WireConnection;492;1;474;2
WireConnection;492;2;496;0
WireConnection;422;0;421;0
WireConnection;4;0;138;1
WireConnection;4;1;138;2
WireConnection;405;0;401;1
WireConnection;405;1;68;4
WireConnection;405;2;426;0
WireConnection;151;0;192;0
WireConnection;151;1;368;0
WireConnection;247;0;141;0
WireConnection;247;1;248;0
WireConnection;423;0;420;0
WireConnection;52;0;51;1
WireConnection;52;1;51;2
WireConnection;217;0;216;0
WireConnection;319;0;492;0
WireConnection;319;1;318;0
WireConnection;319;2;317;0
WireConnection;40;0;4;0
WireConnection;5;0;247;0
WireConnection;424;0;405;0
WireConnection;424;1;423;0
WireConnection;424;2;422;0
WireConnection;218;0;217;0
WireConnection;169;0;151;0
WireConnection;169;1;170;0
WireConnection;57;0;52;0
WireConnection;322;0;319;0
WireConnection;341;0;334;4
WireConnection;56;0;40;0
WireConnection;56;1;57;0
WireConnection;461;0;341;0
WireConnection;425;0;424;0
WireConnection;240;0;218;0
WireConnection;240;1;239;0
WireConnection;270;0;322;0
WireConnection;171;0;151;0
WireConnection;171;1;169;0
WireConnection;171;2;172;0
WireConnection;219;0;240;0
WireConnection;242;0;226;0
WireConnection;242;1;461;0
WireConnection;189;0;151;0
WireConnection;189;1;171;0
WireConnection;189;2;186;0
WireConnection;277;0;56;0
WireConnection;435;0;283;0
WireConnection;407;0;425;0
WireConnection;407;1;406;0
WireConnection;431;0;407;0
WireConnection;431;1;248;0
WireConnection;281;0;189;0
WireConnection;281;1;435;0
WireConnection;281;2;282;0
WireConnection;337;0;226;0
WireConnection;337;1;242;0
WireConnection;276;0;304;0
WireConnection;276;5;290;0
WireConnection;276;8;279;0
WireConnection;276;3;285;0
WireConnection;372;1;40;0
WireConnection;372;0;277;0
WireConnection;408;0;431;0
WireConnection;272;0;372;0
WireConnection;272;1;276;0
WireConnection;272;2;278;0
WireConnection;377;0;337;0
WireConnection;377;1;221;0
WireConnection;384;1;189;0
WireConnection;384;0;281;0
WireConnection;10;0;384;0
WireConnection;410;1;372;0
WireConnection;410;0;272;0
WireConnection;409;1;337;0
WireConnection;409;0;377;0
WireConnection;32;0;33;0
WireConnection;32;1;139;1
WireConnection;9;0;410;0
WireConnection;34;0;35;0
WireConnection;34;1;139;2
WireConnection;412;0;409;0
WireConnection;412;1;413;0
WireConnection;411;0;409;0
WireConnection;411;1;412;0
WireConnection;7;0;34;0
WireConnection;8;0;32;0
WireConnection;462;0;11;0
WireConnection;187;0;15;0
WireConnection;187;1;466;0
WireConnection;187;2;188;0
WireConnection;119;2;17;3
WireConnection;59;0;115;0
WireConnection;443;0;12;0
WireConnection;463;0;462;0
WireConnection;374;1;375;0
WireConnection;374;0;235;0
WireConnection;118;0;119;0
WireConnection;115;2;17;4
WireConnection;18;0;17;1
WireConnection;18;1;17;2
WireConnection;18;2;17;3
WireConnection;414;1;407;0
WireConnection;58;0;18;0
WireConnection;335;0;411;0
WireConnection;335;1;38;0
WireConnection;415;0;414;1
WireConnection;415;1;414;2
WireConnection;415;2;414;3
WireConnection;0;0;463;0
WireConnection;0;1;443;0
WireConnection;0;2;335;0
WireConnection;0;3;13;0
WireConnection;0;4;14;0
WireConnection;0;5;187;0
WireConnection;0;10;374;0
ASEEND*/
//CHKSM=D660BD3FF64DF425262AA0D7BE23486FA976E528
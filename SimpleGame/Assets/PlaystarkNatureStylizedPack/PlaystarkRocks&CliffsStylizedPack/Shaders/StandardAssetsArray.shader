// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Playstark/StandardAssetsArray"
{
	Properties
	{
		_Color0("Color 0", Color) = (0,0,0,0)
		_AlbedoAlpha("Albedo+Alpha", 2DArray ) = "" {}
		_Normal("Normal", 2DArray ) = "" {}
		_MetRoughAOEmit("Met+Rough+AO+Emit", 2DArray ) = "" {}
		_EMITRamp("EMIT Ramp", 2D) = "black" {}
		_NRMLevel("NRM Level", Float) = 1
		_METLevel("MET Level", Float) = 1
		_RGHLevel("RGH Level", Float) = 1
		_EMILevel("EMI Level", Float) = 1
		_AOLevel("AO Level", Range( 0 , 2)) = 0
		[Space(10)][Header(TRIPLANAR)][Space(5)][Toggle(_TRIPLANAR_ACTIVE_ON)] _TRIPLANAR_ACTIVE("TRIPLANAR_ACTIVE", Float) = 0
		_AlbedoTriplanar("Albedo Triplanar", 2DArray) = "white" {}
		_NormalTriplanar("Normal Triplanar", 2DArray) = "white" {}
		_Triplanarintensity("Triplanar intensity", Range( 0 , 1)) = 1
		_TriplanarTile("Triplanar Tile", Float) = 1
		_NRMTriplanarLevel("NRM Triplanar Level", Float) = 1
		[Space(10)][Header(COVERED)][Space(5)][Toggle(_COVEREDACTIVE_ON)] _CoveredActive("CoveredActive", Float) = 0
		[IntRange]_VCNWMMASK("VC / NWM MASK", Range( 0 , 1)) = 0
		_CoveredTile("Covered Tile", Range( 0 , 10)) = 1
		_Offset("Offset", Range( -1 , 1)) = 0
		_Contrast("Contrast", Range( 0 , 0.5)) = 0
		[IntRange]_CoveredIndex("CoveredIndex", Range( 0 , 12)) = 1
		_CoveredAlbedo("CoveredAlbedo", 2DArray) = "white" {}
		_CoveredNormal("CoveredNormal", 2DArray) = "white" {}
		_CoveredNRMLevel("Covered NRM Level", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.0
		#pragma shader_feature _COVEREDACTIVE_ON
		#pragma shader_feature _TRIPLANAR_ACTIVE_ON
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
			float4 vertexColor : COLOR;
			float3 worldPos;
			half3 worldNormal;
			INTERNAL_DATA
		};

		uniform UNITY_DECLARE_TEX2DARRAY( _Normal );
		uniform float4 _Normal_ST;
		uniform float _NRMLevel;
		uniform UNITY_DECLARE_TEX2DARRAY( _NormalTriplanar );
		uniform float _TriplanarTile;
		uniform half _NRMTriplanarLevel;
		uniform UNITY_DECLARE_TEX2DARRAY( _CoveredNormal );
		uniform half _CoveredIndex;
		uniform half _CoveredTile;
		uniform half _CoveredNRMLevel;
		uniform UNITY_DECLARE_TEX2DARRAY( _CoveredAlbedo );
		uniform half _VCNWMMASK;
		uniform half _Offset;
		uniform half _Contrast;
		uniform float4 _Color0;
		uniform UNITY_DECLARE_TEX2DARRAY( _AlbedoAlpha );
		uniform float4 _AlbedoAlpha_ST;
		uniform UNITY_DECLARE_TEX2DARRAY( _AlbedoTriplanar );
		uniform float _Triplanarintensity;
		uniform float _EMILevel;
		uniform sampler2D _EMITRamp;
		uniform UNITY_DECLARE_TEX2DARRAY( _MetRoughAOEmit );
		uniform float4 _MetRoughAOEmit_ST;
		uniform float _METLevel;
		uniform float _RGHLevel;
		uniform float _AOLevel;


		inline float3 TriplanarSamplingSNFA( UNITY_ARGS_TEX2DARRAY( topTexMap ), float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			xNorm = ( UNITY_SAMPLE_TEX2DARRAY( ASE_TEXTURE_PARAMS( topTexMap ), float3( tiling * worldPos.zy * float2( nsign.x, 1.0 ), index.x ) ) );
			yNorm = ( UNITY_SAMPLE_TEX2DARRAY( ASE_TEXTURE_PARAMS( topTexMap ), float3( tiling * worldPos.xz * float2( nsign.y, 1.0 ), index.x ) ) );
			zNorm = ( UNITY_SAMPLE_TEX2DARRAY( ASE_TEXTURE_PARAMS( topTexMap ), float3( tiling * worldPos.xy * float2( -nsign.z, 1.0 ), index.x ) ) );
			xNorm.xyz = half3( UnpackNormal( xNorm ).xy * float2( nsign.x, 1.0 ) + worldNormal.zy, worldNormal.x ).zyx;
			yNorm.xyz = half3( UnpackNormal( yNorm ).xy * float2( nsign.y, 1.0 ) + worldNormal.xz, worldNormal.y ).xzy;
			zNorm.xyz = half3( UnpackNormal( zNorm ).xy * float2( -nsign.z, 1.0 ) + worldNormal.xy, worldNormal.z ).xyz;
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


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			half lerpResult115 = lerp( 0.0 , 255.0 , i.vertexColor.a);
			float VertexAlpha59 = lerpResult115;
			float3 texArray63 = UnpackScaleNormal( UNITY_SAMPLE_TEX2DARRAY(_Normal, float3(uv_Normal, VertexAlpha59)  ), _NRMLevel );
			half2 appendResult4 = (half2(texArray63.x , texArray63.y));
			half3 appendResult40 = (half3(appendResult4 , 1.0));
			float TriplanarTile64 = _TriplanarTile;
			float3 ase_worldPos = i.worldPos;
			half3 ase_worldNormal = WorldNormalVector( i, half3( 0, 0, 1 ) );
			half3 ase_worldTangent = WorldNormalVector( i, half3( 1, 0, 0 ) );
			half3 ase_worldBitangent = WorldNormalVector( i, half3( 0, 1, 0 ) );
			half3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float3 triplanar211 = TriplanarSamplingSNFA( UNITY_PASS_TEX2DARRAY(_NormalTriplanar), ase_worldPos, ase_worldNormal, 1.0, TriplanarTile64, 1.0, 1.0 );
			float3 tanTriplanarNormal211 = mul( ase_worldToTangent, triplanar211 );
			half2 appendResult52 = (half2(tanTriplanarNormal211.x , tanTriplanarNormal211.y));
			half3 appendResult57 = (half3(( appendResult52 * _NRMTriplanarLevel ) , 1.0));
			#ifdef _TRIPLANAR_ACTIVE_ON
				float3 staticSwitch259 = BlendNormals( appendResult40 , appendResult57 );
			#else
				float3 staticSwitch259 = appendResult40;
			#endif
			half CoveredIndex245 = _CoveredIndex;
			half CoveredTile246 = _CoveredTile;
			float3 triplanar251 = TriplanarSamplingSNFA( UNITY_PASS_TEX2DARRAY(_CoveredNormal), ase_worldPos, ase_worldNormal, 1.0, CoveredTile246, 208.08, CoveredIndex245 );
			float3 tanTriplanarNormal251 = mul( ase_worldToTangent, triplanar251 );
			half2 appendResult268 = (half2(tanTriplanarNormal251.x , tanTriplanarNormal251.y));
			half3 appendResult267 = (half3(( appendResult268 * _CoveredNRMLevel ) , 2.0));
			float4 triplanar240 = TriplanarSamplingSFA( UNITY_PASS_TEX2DARRAY(_CoveredAlbedo), ase_worldPos, ase_worldNormal, 1.0, CoveredTile246, 1.0, CoveredIndex245 );
			half CovAlb239 = triplanar240.w;
			float VertexRed120 = i.vertexColor.r;
			float3 CoveredNormal264 = appendResult40;
			half lerpResult229 = lerp( ( CovAlb239 * ( 1.0 - VertexRed120 ) ) , (WorldNormalVector( i , CoveredNormal264 )).y , _VCNWMMASK);
			half clampResult231 = clamp( ( _Offset + _Contrast ) , 0.0 , 1.0 );
			half clampResult230 = clamp( ( _Offset + ( 1.0 - _Contrast ) ) , 0.0 , 1.0 );
			half clampResult233 = clamp( (0.0 + (lerpResult229 - clampResult231) * (1.0 - 0.0) / (clampResult230 - clampResult231)) , 0.0 , 1.0 );
			float Covered_mask234 = clampResult233;
			half3 lerpResult248 = lerp( appendResult40 , appendResult267 , Covered_mask234);
			#ifdef _COVEREDACTIVE_ON
				float3 staticSwitch249 = lerpResult248;
			#else
				float3 staticSwitch249 = staticSwitch259;
			#endif
			float3 nrm9 = staticSwitch249;
			o.Normal = nrm9;
			half3 appendResult144 = (half3(_Color0.r , _Color0.g , _Color0.b));
			float2 uv_AlbedoAlpha = i.uv_texcoord * _AlbedoAlpha_ST.xy + _AlbedoAlpha_ST.zw;
			float4 texArray50 = UNITY_SAMPLE_TEX2DARRAY(_AlbedoAlpha, float3(uv_AlbedoAlpha, VertexAlpha59)  );
			half lerpResult119 = lerp( 0.0 , 255.0 , i.vertexColor.b);
			float VertexBlue118 = lerpResult119;
			float4 triplanar26 = TriplanarSamplingSFA( UNITY_PASS_TEX2DARRAY(_AlbedoTriplanar), ase_worldPos, ase_worldNormal, 1.0, TriplanarTile64, 1.0, VertexBlue118 );
			half4 blendOpSrc260 = triplanar26;
			half4 blendOpDest260 = texArray50;
			half4 lerpResult262 = lerp( texArray50 , ( saturate( (( blendOpDest260 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest260 ) * ( 1.0 - blendOpSrc260 ) ) : ( 2.0 * blendOpDest260 * blendOpSrc260 ) ) )) , _Triplanarintensity);
			#ifdef _TRIPLANAR_ACTIVE_ON
				float4 staticSwitch181 = lerpResult262;
			#else
				float4 staticSwitch181 = texArray50;
			#endif
			half4 temp_output_143_0 = ( half4( appendResult144 , 0.0 ) * staticSwitch181 );
			half4 lerpResult236 = lerp( temp_output_143_0 , triplanar240 , Covered_mask234);
			#ifdef _COVEREDACTIVE_ON
				float4 staticSwitch235 = lerpResult236;
			#else
				float4 staticSwitch235 = temp_output_143_0;
			#endif
			float4 albedo10 = staticSwitch235;
			o.Albedo = albedo10.xyz;
			float2 uv_MetRoughAOEmit = i.uv_texcoord * _MetRoughAOEmit_ST.xy + _MetRoughAOEmit_ST.zw;
			float4 texArray69 = UNITY_SAMPLE_TEX2DARRAY(_MetRoughAOEmit, float3(uv_MetRoughAOEmit, VertexAlpha59)  );
			half clampResult139 = clamp( texArray69.w , 0.01 , 1.0 );
			half2 temp_cast_3 = (clampResult139).xx;
			half4 tex2DNode84 = tex2D( _EMITRamp, temp_cast_3 );
			half3 appendResult116 = (half3(tex2DNode84.r , tex2DNode84.g , tex2DNode84.b));
			float3 emit5 = ( _EMILevel * appendResult116 );
			o.Emission = emit5;
			float metal8 = ( texArray69.x * _METLevel );
			o.Metallic = metal8;
			float rough7 = ( ( 1.0 - texArray69.y ) * _RGHLevel );
			o.Smoothness = rough7;
			half lerpResult82 = lerp( 1.0 , texArray69.z , _AOLevel);
			float ao6 = lerpResult82;
			o.Occlusion = ao6;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma exclude_renderers xbox360 xboxone ps4 psp2 wiiu 
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
				float2 customPack1 : TEXCOORD1;
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
147;94;1394;829;5877.084;211.9518;5.729663;True;False
Node;AmplifyShaderEditor.CommentaryNode;135;-2592.083,-2809.454;Inherit;False;1524.141;1158.664;;14;58;120;18;118;64;119;41;59;115;17;244;245;246;247;CONTROLS;0.5588235,0.9634888,1,1;0;0
Node;AmplifyShaderEditor.VertexColorNode;17;-2542.083,-2428.841;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;115;-1920.644,-2290.135;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;255;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;133;-2828.815,-165.0461;Inherit;False;3030.596;1142.016;;27;254;9;249;259;248;56;250;267;268;40;57;277;4;212;52;53;251;253;252;255;211;127;66;264;63;31;62;NORMAL;0.6029412,0.6056795,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;59;-1714.869,-2293.773;Float;False;VertexAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;62;-2675.465,-40.77291;Inherit;False;59;VertexAlpha;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-2732.17,41.79427;Float;False;Property;_NRMLevel;NRM Level;5;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;244;-2455.256,-2076.593;Half;False;Property;_CoveredIndex;CoveredIndex;21;1;[IntRange];Create;True;0;0;False;0;1;5;0;12;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;247;-2448.135,-1926.972;Half;False;Property;_CoveredTile;Covered Tile;18;0;Create;True;0;0;False;0;1;0.14;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;245;-2062.256,-2076.593;Half;False;CoveredIndex;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureArrayNode;63;-2422.224,-93.28075;Float;True;Property;_Normal;Normal;2;0;Create;True;0;0;False;0;None;0;Object;-1;Auto;True;7;6;SAMPLER2D;;False;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;246;-2063.736,-1928.469;Half;False;CoveredTile;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;132;-2896.235,-1459.726;Inherit;False;4072.628;1139.171;;22;10;235;236;243;242;241;240;239;238;181;173;143;144;142;26;50;121;65;125;61;260;262;ALBEDO;1,0.7058823,0.7058823,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;242;-1148.267,-421.473;Inherit;False;246;CoveredTile;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;241;-1151.768,-512.0885;Inherit;False;245;CoveredIndex;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;4;-2034,-115.0461;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;243;-1157.138,-720.9079;Float;True;Property;_CoveredAlbedo;CoveredAlbedo;22;0;Create;True;0;0;False;0;None;9c13493d23556284b94cdc86bab2273c;False;white;Auto;Texture2DArray;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;120;-1739.163,-2509.229;Float;False;VertexRed;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;40;-1606.675,-115.4799;Inherit;True;FLOAT3;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;213;-2780.723,2743.066;Inherit;False;1130.989;425.5272;COVERED VERTEX COLOR MASK;4;226;223;221;218;COVERED VERTEX COLOR MASK;1,1,1,1;0;0
Node;AmplifyShaderEditor.TriplanarNode;240;-842.2094,-686.3627;Inherit;True;Spherical;World;False;CoveredALB;_CoveredALB;white;28;None;Mid Texture 4;_MidTexture4;white;-1;None;Bot Texture 4;_BotTexture4;white;-1;None;CoveredAlbedoTriplanar;True;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;214;-2766.652,3411.16;Inherit;False;1142.25;516.0505;COVERED WORLD NORMAL MASK;2;228;216;COVERED WORLD NORMAL MASK;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;217;-1047.29,3543.519;Half;False;Constant;_Float6;Float 6;6;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-2427.874,-2755.36;Float;False;Property;_TriplanarTile;Triplanar Tile;14;0;Create;True;0;0;False;0;1;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;215;-1075.051,3321.613;Half;False;Property;_Contrast;Contrast;20;0;Create;True;0;0;False;0;0;0.409;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;119;-1912.163,-2425.229;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;255;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;218;-2656.297,2965.331;Inherit;False;120;VertexRed;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;239;-399.5101,-586.2843;Half;True;CovAlb;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;264;-1184.747,321.4653;Float;False;CoveredNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;219;-857.6757,3545.652;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;64;-2135.914,-2759.454;Float;False;TriplanarTile;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;216;-2446.423,3641.086;Inherit;False;264;CoveredNormal;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;220;-1080.508,3180.116;Half;False;Property;_Offset;Offset;19;0;Create;True;0;0;False;0;0;-0.001;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;223;-2648.401,2861.612;Inherit;False;239;CovAlb;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;221;-2443.87,2969.231;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;118;-1724.163,-2412.229;Float;False;VertexBlue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;225;-675.4792,3499.712;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;65;-2828.651,-568.9415;Inherit;False;64;TriplanarTile;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;227;-1518.818,3377.704;Half;False;Property;_VCNWMMASK;VC / NWM MASK;17;1;[IntRange];Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;226;-2179.74,2849.764;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;228;-2073.895,3638.33;Inherit;True;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;224;-655.3442,3227.39;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;121;-2820.329,-656.3906;Inherit;False;118;VertexBlue;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;61;-2800.135,-1093.285;Inherit;False;59;VertexAlpha;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;127;-2767.569,219.9606;Float;True;Property;_NormalTriplanar;Normal Triplanar;12;0;Create;True;0;0;False;0;None;None;False;white;Auto;Texture2DArray;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;66;-2735.889,505.0374;Inherit;False;64;TriplanarTile;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;125;-2846.29,-848.2935;Float;True;Property;_AlbedoTriplanar;Albedo Triplanar;11;0;Create;True;0;0;False;0;None;None;False;white;Auto;Texture2DArray;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.ClampOpNode;231;-485.6595,3223.987;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureArrayNode;50;-2555.274,-1137.466;Float;True;Property;_AlbedoAlpha;Albedo+Alpha;1;0;Create;True;0;0;False;0;None;0;Object;-1;Auto;False;7;6;SAMPLER2D;;False;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;230;-515.5826,3474.204;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;229;-1278.138,2856.065;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;134;-2790.163,1214.585;Inherit;False;3301.204;1225.587;;19;180;69;5;7;6;8;39;34;32;82;35;36;33;206;116;38;84;139;70;METAL + ROUGH + AO + EMIT;0.7132353,1,0.7152129,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;254;-2451.852,817.9764;Inherit;False;246;CoveredTile;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;252;-2486.941,529.0331;Inherit;False;245;CoveredIndex;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;26;-2516.173,-809.1826;Inherit;True;Spherical;World;False;Albedo Triplanar Base;_AlbedoTriplanarBase;white;1;None;Mid Texture 0;_MidTexture0;white;-1;None;Bot Texture 0;_BotTexture0;white;-1;None;Albedo Triplanar Base;True;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TriplanarNode;211;-2462.526,225.2088;Inherit;True;Spherical;World;True;Normal Triplanar Base;_NormalTriplanarBase;white;15;None;Mid Texture 3;_MidTexture3;white;-1;None;Bot Texture 3;_BotTexture3;white;-1;None;Normal Triplanar Base;True;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;255;-2799.951,599.5464;Float;True;Property;_CoveredNormal;CoveredNormal;23;0;Create;True;0;0;False;0;None;9442314057dead14495529513d77fbc1;False;white;Auto;Texture2DArray;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;173;-1807.978,-472.4642;Float;False;Property;_Triplanarintensity;Triplanar intensity;13;0;Create;True;0;0;False;0;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;260;-2039.33,-821.3307;Inherit;True;Overlay;True;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-2039.178,488.3876;Half;False;Property;_NRMTriplanarLevel;NRM Triplanar Level;15;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;52;-2033.771,249.7306;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;70;-2461.542,1364.701;Inherit;False;59;VertexAlpha;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;251;-2225.256,587.2126;Inherit;True;Spherical;World;True;CoveredNRM;_CoveredNRM;white;27;None;Mid Texture 1;_MidTexture1;white;-1;None;Bot Texture 1;_BotTexture1;white;-1;None;CoveredNormalTriplanar;True;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;208.08;False;3;FLOAT;1;False;4;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;232;-204.7532,3211.362;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0.4;False;2;FLOAT;0.6;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;253;-1807.108,804.612;Half;False;Property;_CoveredNRMLevel;Covered NRM Level;24;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;268;-1768.04,536.55;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;142;-1629.182,-1409.944;Float;False;Property;_Color0;Color 0;0;0;Create;True;0;0;False;0;0,0,0,0;1,0.5516975,0.4941176,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;212;-1772.045,258.1344;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;262;-1402.458,-774.0306;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;1,1,1,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TextureArrayNode;69;-2238.633,1321.704;Float;True;Property;_MetRoughAOEmit;Met+Rough+AO+Emit;3;0;Create;True;0;0;False;0;None;0;Object;-1;Auto;False;7;6;SAMPLER2D;;False;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;233;72.38195,3207.567;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;144;-1385.629,-1382.048;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;234;228.4698,3200.753;Float;True;Covered_mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;57;-1570.201,253.6033;Inherit;True;FLOAT3;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;277;-1525.886,527.5866;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;139;-1666.724,1658.03;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.01;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;181;-1037.834,-1225.3;Float;True;Property;_TRIPLANAR_ACTIVE;TRIPLANAR_ACTIVE;10;0;Create;True;0;0;False;3;Space(10);Header(TRIPLANAR);Space(5);0;0;0;True;;Toggle;2;Key0;Key1;Create;False;9;1;FLOAT4;0,0,0,0;False;0;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;5;FLOAT4;0,0,0,0;False;6;FLOAT4;0,0,0,0;False;7;FLOAT4;0,0,0,0;False;8;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;84;-1331.509,1816.864;Inherit;True;Property;_EMITRamp;EMIT Ramp;4;0;Create;True;0;0;False;0;-1;0c1654a137d7df741b6e1a143703a9a8;0c1654a137d7df741b6e1a143703a9a8;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;238;-183.742,-669.3774;Inherit;False;234;Covered_mask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;56;-1191.385,28.40138;Inherit;True;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;267;-1341.345,510.4346;Inherit;True;FLOAT3;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;2;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;250;-659.3412,663.7776;Inherit;False;234;Covered_mask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;143;-666.0368,-1303.093;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;116;-974.2322,1844.242;Inherit;True;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;259;-834.1844,-96.95968;Float;True;Property;_TRIPLANAR_ACTIVE;TRIPLANAR_ACTIVE;10;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Reference;181;False;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-1116.199,1440.278;Float;False;Property;_RGHLevel;RGH Level;7;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-1117.279,1334.971;Float;False;Property;_METLevel;MET Level;6;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;180;-1363.985,1367.615;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-672.2031,1628.376;Float;False;Property;_EMILevel;EMI Level;8;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;206;-1361.88,1463.158;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-1226.138,1564.812;Float;False;Property;_AOLevel;AO Level;9;0;Create;True;0;0;False;0;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;236;60.9314,-1001.239;Inherit;True;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;248;-410.7063,311.2281;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-876.3619,1275.987;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-878.3339,1373.06;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;235;382.6272,-1256.785;Float;False;Property;_CoveredActive;CoveredActive;16;0;Create;True;0;0;False;3;Space(10);Header(COVERED);Space(5);0;0;0;True;;Toggle;2;Key0;Key1;Create;False;9;1;FLOAT4;0,0,0,0;False;0;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;5;FLOAT4;0,0,0,0;False;6;FLOAT4;0,0,0,0;False;7;FLOAT4;0,0,0,0;False;8;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-444.3099,1640.083;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;82;-876.2929,1494.111;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;249;-328.9369,-45.03226;Float;False;Property;_CoveredActive;CoveredActive;16;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Reference;235;False;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;9;-6.335938,-54.58561;Float;False;nrm;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;136;1398.135,-1447.158;Inherit;False;1039.076;685.6845;;7;12;14;13;16;11;15;0;SHADER;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;7;-229.5146,1386.672;Float;False;rough;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;8;-231.2544,1274.696;Float;False;metal;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;6;-223.1426,1500.495;Float;False;ao;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;5;-197.0403,1627.922;Float;False;emit;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;10;787.8186,-1256.879;Float;False;albedo;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;16;1454.135,-1224.158;Inherit;False;5;emit;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;58;-2087.658,-2566.552;Float;False;VertexRGB;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;12;1451.135,-1318.158;Inherit;False;9;nrm;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;11;1448.135,-1397.158;Inherit;False;10;albedo;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;13;1457.135,-1147.158;Inherit;False;8;metal;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;18;-2229.184,-2562.742;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;15;1468.135,-930.1581;Inherit;False;6;ao;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;14;1460.135,-1024.158;Inherit;False;7;rough;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2174.211,-1216.474;Half;False;True;-1;4;ASEMaterialInspector;0;0;Standard;Playstark/StandardAssetsArray;False;False;False;False;False;False;False;True;False;True;False;False;True;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;9;d3d9;d3d11_9x;d3d11;glcore;gles;gles3;metal;vulkan;n3ds;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;115;2;17;4
WireConnection;59;0;115;0
WireConnection;245;0;244;0
WireConnection;63;1;62;0
WireConnection;63;3;31;0
WireConnection;246;0;247;0
WireConnection;4;0;63;1
WireConnection;4;1;63;2
WireConnection;120;0;17;1
WireConnection;40;0;4;0
WireConnection;240;0;243;0
WireConnection;240;5;241;0
WireConnection;240;3;242;0
WireConnection;119;2;17;3
WireConnection;239;0;240;4
WireConnection;264;0;40;0
WireConnection;219;0;217;0
WireConnection;219;1;215;0
WireConnection;64;0;41;0
WireConnection;221;0;218;0
WireConnection;118;0;119;0
WireConnection;225;0;220;0
WireConnection;225;1;219;0
WireConnection;226;0;223;0
WireConnection;226;1;221;0
WireConnection;228;0;216;0
WireConnection;224;0;220;0
WireConnection;224;1;215;0
WireConnection;231;0;224;0
WireConnection;50;1;61;0
WireConnection;230;0;225;0
WireConnection;229;0;226;0
WireConnection;229;1;228;2
WireConnection;229;2;227;0
WireConnection;26;0;125;0
WireConnection;26;5;121;0
WireConnection;26;3;65;0
WireConnection;211;0;127;0
WireConnection;211;3;66;0
WireConnection;260;0;26;0
WireConnection;260;1;50;0
WireConnection;52;0;211;1
WireConnection;52;1;211;2
WireConnection;251;0;255;0
WireConnection;251;5;252;0
WireConnection;251;3;254;0
WireConnection;232;0;229;0
WireConnection;232;1;231;0
WireConnection;232;2;230;0
WireConnection;268;0;251;1
WireConnection;268;1;251;2
WireConnection;212;0;52;0
WireConnection;212;1;53;0
WireConnection;262;0;50;0
WireConnection;262;1;260;0
WireConnection;262;2;173;0
WireConnection;69;1;70;0
WireConnection;233;0;232;0
WireConnection;144;0;142;1
WireConnection;144;1;142;2
WireConnection;144;2;142;3
WireConnection;234;0;233;0
WireConnection;57;0;212;0
WireConnection;277;0;268;0
WireConnection;277;1;253;0
WireConnection;139;0;69;4
WireConnection;181;1;50;0
WireConnection;181;0;262;0
WireConnection;84;1;139;0
WireConnection;56;0;40;0
WireConnection;56;1;57;0
WireConnection;267;0;277;0
WireConnection;143;0;144;0
WireConnection;143;1;181;0
WireConnection;116;0;84;1
WireConnection;116;1;84;2
WireConnection;116;2;84;3
WireConnection;259;1;40;0
WireConnection;259;0;56;0
WireConnection;180;0;69;2
WireConnection;206;0;69;3
WireConnection;236;0;143;0
WireConnection;236;1;240;0
WireConnection;236;2;238;0
WireConnection;248;0;40;0
WireConnection;248;1;267;0
WireConnection;248;2;250;0
WireConnection;32;0;69;1
WireConnection;32;1;33;0
WireConnection;34;0;180;0
WireConnection;34;1;35;0
WireConnection;235;1;143;0
WireConnection;235;0;236;0
WireConnection;39;0;38;0
WireConnection;39;1;116;0
WireConnection;82;1;206;0
WireConnection;82;2;36;0
WireConnection;249;1;259;0
WireConnection;249;0;248;0
WireConnection;9;0;249;0
WireConnection;7;0;34;0
WireConnection;8;0;32;0
WireConnection;6;0;82;0
WireConnection;5;0;39;0
WireConnection;10;0;235;0
WireConnection;58;0;18;0
WireConnection;18;0;17;1
WireConnection;18;1;17;2
WireConnection;18;2;17;3
WireConnection;0;0;11;0
WireConnection;0;1;12;0
WireConnection;0;2;16;0
WireConnection;0;3;13;0
WireConnection;0;4;14;0
WireConnection;0;5;15;0
ASEEND*/
//CHKSM=185C9A26A53CA452C038552FE05DD2768FE84FBC
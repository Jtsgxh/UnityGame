// Upgrade NOTE: upgraded instancing buffer 'PlaystarkTerrainBlendingCliff' to new syntax.

// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Playstark/TerrainBlendingCliff"
{
	Properties
	{
		_AlbedoAlpha("Albedo+Alpha", 2DArray) = "white" {}
		_Texture0("Texture 0", 2DArray) = "white" {}
		_Smothness("Smothness", Range( 0 , 1)) = 0
		_NRMLevel("NRM Level", Float) = 1
		_BlendStrenght("BlendStrenght", Float) = 0
		_BlendStrenght2("BlendStrenght2", Float) = 0
		[IntRange]_CoverTexture("CoverTexture", Range( 0 , 10)) = 0
		_Tiling("Tiling", Float) = 0
		[IntRange]_BaseTexture("BaseTexture", Range( 0 , 10)) = 0
		[IntRange]_BaseTexture2("BaseTexture2", Range( 0 , 10)) = 0
		[Toggle]_2ndBaseTexture("2ndBaseTexture", Float) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.0
		#pragma multi_compile_instancing
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
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float4 vertexColor : COLOR;
		};

		uniform UNITY_DECLARE_TEX2DARRAY( _Texture0 );
		uniform float _NRMLevel;
		uniform UNITY_DECLARE_TEX2DARRAY( _AlbedoAlpha );
		uniform float _BlendStrenght2;
		uniform float _2ndBaseTexture;
		uniform float _BlendStrenght;
		uniform float _Smothness;

		UNITY_INSTANCING_BUFFER_START(PlaystarkTerrainBlendingCliff)
			UNITY_DEFINE_INSTANCED_PROP(float, _BaseTexture)
#define _BaseTexture_arr PlaystarkTerrainBlendingCliff
			UNITY_DEFINE_INSTANCED_PROP(float, _Tiling)
#define _Tiling_arr PlaystarkTerrainBlendingCliff
			UNITY_DEFINE_INSTANCED_PROP(float, _BaseTexture2)
#define _BaseTexture2_arr PlaystarkTerrainBlendingCliff
			UNITY_DEFINE_INSTANCED_PROP(float, _CoverTexture)
#define _CoverTexture_arr PlaystarkTerrainBlendingCliff
		UNITY_INSTANCING_BUFFER_END(PlaystarkTerrainBlendingCliff)


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


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float _BaseTexture_Instance = UNITY_ACCESS_INSTANCED_PROP(_BaseTexture_arr, _BaseTexture);
			float BaseTextureIndex184 = _BaseTexture_Instance;
			float _Tiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_Tiling_arr, _Tiling);
			float temp_output_445_0 = ( _Tiling_Instance * 0.1 );
			float2 appendResult446 = (float2(temp_output_445_0 , temp_output_445_0));
			float2 Tiling449 = appendResult446;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float4 ase_vertexTangent = mul( unity_WorldToObject, float4( ase_worldTangent, 0 ) );
			float3 ase_vertexBitangent = mul( unity_WorldToObject, float4( ase_worldBitangent, 0 ) );
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			float3x3 objectToTangent = float3x3(ase_vertexTangent.xyz, ase_vertexBitangent, ase_vertexNormal);
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float3 triplanar375 = TriplanarSamplingSNFA( UNITY_PASS_TEX2DARRAY(_Texture0), ase_vertex3Pos, ase_vertexNormal, 1.0, Tiling449, _NRMLevel, BaseTextureIndex184 );
			float3 tanTriplanarNormal375 = mul( objectToTangent, triplanar375 );
			float2 appendResult4 = (float2(tanTriplanarNormal375.x , tanTriplanarNormal375.y));
			float3 appendResult40 = (float3(appendResult4 , 1.0));
			float _BaseTexture2_Instance = UNITY_ACCESS_INSTANCED_PROP(_BaseTexture2_arr, _BaseTexture2);
			float BaseTexture2Index379 = _BaseTexture2_Instance;
			float3 triplanar400 = TriplanarSamplingSNFA( UNITY_PASS_TEX2DARRAY(_Texture0), ase_vertex3Pos, ase_vertexNormal, 1.0, Tiling449, _NRMLevel, BaseTexture2Index379 );
			float3 tanTriplanarNormal400 = mul( objectToTangent, triplanar400 );
			float2 appendResult402 = (float2(tanTriplanarNormal400.x , tanTriplanarNormal400.y));
			float3 appendResult403 = (float3(appendResult402 , 1.0));
			float4 triplanar373 = TriplanarSamplingSFA( UNITY_PASS_TEX2DARRAY(_AlbedoAlpha), ase_vertex3Pos, ase_vertexNormal, 1.0, Tiling449, 1.0, BaseTextureIndex184 );
			float clampResult411 = clamp( i.vertexColor.r , 0.0 , 1.0 );
			float HeightMask382 = saturate(pow(((( 1.0 - triplanar373.w )*clampResult411)*4)+(clampResult411*2),_BlendStrenght2));
			float clampResult384 = clamp( HeightMask382 , 0.0 , 1.0 );
			float mask2383 = clampResult384;
			float3 lerpResult393 = lerp( appendResult40 , appendResult403 , mask2383);
			float BoolBaseTexture2396 = (( _2ndBaseTexture )?( 1.0 ):( 0.0 ));
			float3 lerpResult394 = lerp( appendResult40 , lerpResult393 , BoolBaseTexture2396);
			float _CoverTexture_Instance = UNITY_ACCESS_INSTANCED_PROP(_CoverTexture_arr, _CoverTexture);
			float CoverTextureIndex120 = _CoverTexture_Instance;
			float3 triplanar376 = TriplanarSamplingSNFA( UNITY_PASS_TEX2DARRAY(_Texture0), ase_vertex3Pos, ase_vertexNormal, 1.0, Tiling449, _NRMLevel, CoverTextureIndex120 );
			float3 tanTriplanarNormal376 = mul( objectToTangent, triplanar376 );
			float2 appendResult325 = (float2(tanTriplanarNormal376.x , tanTriplanarNormal376.y));
			float3 appendResult326 = (float3(appendResult325 , 1.0));
			float4 triplanar374 = TriplanarSamplingSFA( UNITY_PASS_TEX2DARRAY(_AlbedoAlpha), ase_vertex3Pos, ase_vertexNormal, 1.0, Tiling449, 1.0, CoverTextureIndex120 );
			float clampResult410 = clamp( ( ase_worldNormal.y * 1.0 ) , 0.0 , 1.0 );
			float HeightMask330 = saturate(pow(((( ( 1.0 - triplanar373.w ) * triplanar374.w )*clampResult410)*4)+(clampResult410*2),_BlendStrenght));
			float clampResult346 = clamp( HeightMask330 , 0.0 , 1.0 );
			float CoveredMask347 = clampResult346;
			float3 lerpResult327 = lerp( lerpResult394 , appendResult326 , CoveredMask347);
			float3 NormalArray262 = lerpResult327;
			o.Normal = NormalArray262;
			float3 appendResult320 = (float3(triplanar373.x , triplanar373.y , triplanar373.z));
			float4 triplanar378 = TriplanarSamplingSFA( UNITY_PASS_TEX2DARRAY(_AlbedoAlpha), ase_vertex3Pos, ase_vertexNormal, 1.0, Tiling449, 1.0, BaseTexture2Index379 );
			float3 appendResult388 = (float3(triplanar378.x , triplanar378.y , triplanar378.z));
			float3 lerpResult381 = lerp( appendResult320 , appendResult388 , clampResult384);
			float3 lerpResult387 = lerp( appendResult320 , lerpResult381 , BoolBaseTexture2396);
			float3 appendResult321 = (float3(triplanar374.x , triplanar374.y , triplanar374.z));
			float3 lerpResult318 = lerp( lerpResult387 , appendResult321 , CoveredMask347);
			float3 albedo10 = lerpResult318;
			o.Albedo = albedo10;
			o.Smoothness = _Smothness;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows nofog dithercrossfade 

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
				float4 tSpace0 : TEXCOORD1;
				float4 tSpace1 : TEXCOORD2;
				float4 tSpace2 : TEXCOORD3;
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
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
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
-12;120;1298;829;4558.953;1619.321;4.193672;True;False
Node;AmplifyShaderEditor.CommentaryNode;135;-2552.641,-2686.317;Inherit;False;1895.311;1218.187;;19;367;445;449;446;41;58;17;59;118;18;64;396;389;379;120;380;349;184;350;CONTROLS;0.5588235,0.9634888,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;367;-1620.848,-2463.011;Float;False;InstancedProperty;_Tiling;Tiling;8;0;Create;True;0;0;False;0;0;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;445;-1446.244,-2457.702;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;446;-1235.627,-2467.492;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;350;-1562.158,-2057.454;Float;False;InstancedProperty;_BaseTexture;BaseTexture;9;1;[IntRange];Create;True;0;0;False;0;0;2;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;184;-1238.647,-2058.005;Float;False;BaseTextureIndex;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;449;-964.5842,-2474.078;Inherit;False;Tiling;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;132;-2557.051,-1275.996;Inherit;False;2853.645;1587.368;;31;320;10;318;321;347;61;346;330;344;336;315;311;340;369;373;374;378;381;382;383;384;387;388;390;398;404;406;410;411;413;415;ALBEDO;1,0.7058823,0.7058823,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;315;-2502.388,-453.1708;Inherit;False;184;BaseTextureIndex;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;369;-2438.485,-295.5572;Inherit;False;449;Tiling;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;311;-2498.656,-805.6739;Float;True;Property;_AlbedoAlpha;Albedo+Alpha;0;0;Create;True;0;0;False;0;None;9c13493d23556284b94cdc86bab2273c;False;white;Auto;Texture2DArray;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;349;-1561.158,-2165.454;Float;False;InstancedProperty;_CoverTexture;CoverTexture;7;1;[IntRange];Create;True;0;0;False;0;0;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;373;-2052.475,-647.4705;Inherit;True;Spherical;Object;False;Top Texture 0;_TopTexture0;white;-1;None;Mid Texture 0;_MidTexture0;white;-1;None;Bot Texture 0;_BotTexture0;white;-1;None;Triplanar Sampler;True;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;380;-1563.613,-1963.491;Float;False;InstancedProperty;_BaseTexture2;BaseTexture2;10;1;[IntRange];Create;True;0;0;False;0;0;3;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;120;-1242.008,-2165.439;Float;False;CoverTextureIndex;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;406;-2377.938,-1223.877;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;415;-1645.245,-1071.476;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;390;-2044.308,-1095.168;Float;False;Property;_BlendStrenght2;BlendStrenght2;6;0;Create;True;0;0;False;0;0;3.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;133;-2541.79,475.4839;Inherit;False;2700.973;1082.712;;22;394;399;393;392;328;327;262;40;326;4;325;376;375;324;62;372;329;31;400;401;402;403;NORMAL;0.6029412,0.6056795,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;379;-1235.507,-1965.02;Float;False;BaseTexture2Index;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;411;-1884.687,-1234.732;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;61;-2492.179,-167.451;Inherit;False;120;CoverTextureIndex;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;340;-2461.701,-52.7067;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;62;-2521.677,996.8349;Inherit;False;184;BaseTextureIndex;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;413;-1460.184,-220.6813;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.HeightMapBlendNode;382;-1431.68,-1240.486;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;11.09;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;372;-2428.408,1414.393;Inherit;False;449;Tiling;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;336;-2226.039,0.1998374;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;329;-2532.107,780.9438;Float;True;Property;_Texture0;Texture 0;1;0;Create;True;0;0;False;0;None;9442314057dead14495529513d77fbc1;False;white;Auto;Texture2DArray;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-2490.591,1124.945;Float;False;Property;_NRMLevel;NRM Level;3;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;401;-2512.528,630.4938;Inherit;False;379;BaseTexture2Index;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;374;-2047.412,-329.8221;Inherit;True;Spherical;Object;False;Top Texture 1;_TopTexture1;white;-1;None;Mid Texture 1;_MidTexture1;white;-1;None;Bot Texture 1;_BotTexture1;white;-1;None;Triplanar Sampler;True;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;2,5.41;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TriplanarNode;375;-2119.02,835.6848;Inherit;True;Spherical;Object;True;Top Texture 2;_TopTexture2;white;-1;None;Mid Texture 2;_MidTexture2;white;-1;None;Bot Texture 2;_BotTexture2;white;-1;None;Triplanar Sampler;True;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;384;-1195.691,-1238.244;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;400;-2114.759,574.4069;Inherit;True;Spherical;Object;True;Top Texture 5;_TopTexture5;white;-1;None;Mid Texture 5;_MidTexture5;white;-1;None;Bot Texture 5;_BotTexture5;white;-1;None;Triplanar Sampler;True;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;344;-1280.715,160.8165;Float;False;Property;_BlendStrenght;BlendStrenght;5;0;Create;True;0;0;False;0;0;31.79;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;414;-1247.145,-170.8107;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;410;-1245.264,3.005719;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;404;-2511.67,-941.2731;Inherit;False;379;BaseTexture2Index;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;383;-942.3622,-1244.967;Float;False;mask2;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.HeightMapBlendNode;330;-1011.975,-172.8391;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;11.09;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;4;-1616.652,867.6227;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TriplanarNode;378;-2061.24,-970.454;Inherit;True;Spherical;Object;False;Top Texture 4;_TopTexture4;white;-1;None;Mid Texture 4;_MidTexture4;white;-1;None;Bot Texture 4;_BotTexture4;white;-1;None;Triplanar Sampler;True;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;324;-2509.464,1258.042;Inherit;False;120;CoverTextureIndex;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;389;-1565.377,-1596.664;Inherit;False;Property;_2ndBaseTexture;2ndBaseTexture;11;0;Create;True;0;0;False;0;1;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;402;-1616.774,595.6008;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;320;-1440.207,-622.2076;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;40;-1351.44,854.3007;Inherit;True;FLOAT3;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;396;-1244.722,-1597.962;Float;False;BoolBaseTexture2;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;403;-1355.049,586.5788;Inherit;True;FLOAT3;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;392;-1123.059,762.1149;Inherit;False;383;mask2;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;376;-2110.891,1108.051;Inherit;True;Spherical;Object;True;Top Texture 3;_TopTexture3;white;-1;None;Mid Texture 3;_MidTexture3;white;-1;None;Bot Texture 3;_BotTexture3;white;-1;None;Triplanar Sampler;True;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;388;-1460.128,-946.4454;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;346;-716.4543,-172.6824;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;381;-947.8639,-960.4311;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;325;-1614.984,1101.641;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;347;-450.8184,-382.7904;Float;False;CoveredMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;399;-1077.268,1000.087;Inherit;False;396;BoolBaseTexture2;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;393;-868.986,616.4147;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;398;-1162.381,-605.1308;Inherit;False;396;BoolBaseTexture2;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;326;-1317.772,1103.32;Inherit;True;FLOAT3;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;321;-1577.749,-381.3021;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;387;-707.3085,-828.0442;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;394;-698.8019,835.9307;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;328;-700.5741,1086.607;Inherit;False;347;CoveredMask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;327;-451.8807,881.4439;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;318;-133.7209,-587.8325;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;10;55.10829,-594.1381;Float;False;albedo;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;136;748.6455,-1679.369;Inherit;False;789.057;681.1796;;4;145;12;11;0;SHADER;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;262;-185.6542,874.4659;Float;True;NormalArray;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;18;-2206.025,-2141.696;Inherit;True;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;118;-1566.007,-1851.439;Float;False;VertexBlue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;11;915.4601,-1573.692;Inherit;False;10;albedo;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;12;889.6246,-1491.211;Inherit;False;262;NormalArray;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;145;821.3775,-1405.202;Float;False;Property;_Smothness;Smothness;2;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;59;-1567.001,-1723.449;Float;False;VertexAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;17;-2491.927,-2044.051;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;41;-2210.715,-2247.315;Float;False;Property;_TriplanarTile;Triplanar Tile;4;0;Create;True;0;0;False;0;1;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;64;-1950.115,-2245.962;Float;False;TriplanarTile;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;58;-1970.526,-2148.535;Float;False;VertexRGB;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1246.169,-1567.452;Float;False;True;-1;4;ASEMaterialInspector;0;0;Standard;Playstark/TerrainBlendingCliff;False;False;False;False;False;False;False;False;False;True;False;False;True;False;True;False;True;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;445;0;367;0
WireConnection;446;0;445;0
WireConnection;446;1;445;0
WireConnection;184;0;350;0
WireConnection;449;0;446;0
WireConnection;373;0;311;0
WireConnection;373;5;315;0
WireConnection;373;3;369;0
WireConnection;120;0;349;0
WireConnection;415;0;373;4
WireConnection;379;0;380;0
WireConnection;411;0;406;1
WireConnection;413;0;373;4
WireConnection;382;0;415;0
WireConnection;382;1;411;0
WireConnection;382;2;390;0
WireConnection;336;0;340;2
WireConnection;374;0;311;0
WireConnection;374;5;61;0
WireConnection;374;3;369;0
WireConnection;375;0;329;0
WireConnection;375;5;62;0
WireConnection;375;8;31;0
WireConnection;375;3;372;0
WireConnection;384;0;382;0
WireConnection;400;0;329;0
WireConnection;400;5;401;0
WireConnection;400;8;31;0
WireConnection;400;3;372;0
WireConnection;414;0;413;0
WireConnection;414;1;374;4
WireConnection;410;0;336;0
WireConnection;383;0;384;0
WireConnection;330;0;414;0
WireConnection;330;1;410;0
WireConnection;330;2;344;0
WireConnection;4;0;375;1
WireConnection;4;1;375;2
WireConnection;378;0;311;0
WireConnection;378;5;404;0
WireConnection;378;3;369;0
WireConnection;402;0;400;1
WireConnection;402;1;400;2
WireConnection;320;0;373;1
WireConnection;320;1;373;2
WireConnection;320;2;373;3
WireConnection;40;0;4;0
WireConnection;396;0;389;0
WireConnection;403;0;402;0
WireConnection;376;0;329;0
WireConnection;376;5;324;0
WireConnection;376;8;31;0
WireConnection;376;3;372;0
WireConnection;388;0;378;1
WireConnection;388;1;378;2
WireConnection;388;2;378;3
WireConnection;346;0;330;0
WireConnection;381;0;320;0
WireConnection;381;1;388;0
WireConnection;381;2;384;0
WireConnection;325;0;376;1
WireConnection;325;1;376;2
WireConnection;347;0;346;0
WireConnection;393;0;40;0
WireConnection;393;1;403;0
WireConnection;393;2;392;0
WireConnection;326;0;325;0
WireConnection;321;0;374;1
WireConnection;321;1;374;2
WireConnection;321;2;374;3
WireConnection;387;0;320;0
WireConnection;387;1;381;0
WireConnection;387;2;398;0
WireConnection;394;0;40;0
WireConnection;394;1;393;0
WireConnection;394;2;399;0
WireConnection;327;0;394;0
WireConnection;327;1;326;0
WireConnection;327;2;328;0
WireConnection;318;0;387;0
WireConnection;318;1;321;0
WireConnection;318;2;347;0
WireConnection;10;0;318;0
WireConnection;262;0;327;0
WireConnection;18;0;17;1
WireConnection;18;1;17;2
WireConnection;18;2;17;3
WireConnection;118;0;17;3
WireConnection;59;0;17;4
WireConnection;64;0;41;0
WireConnection;58;0;18;0
WireConnection;0;0;11;0
WireConnection;0;1;12;0
WireConnection;0;4;145;0
ASEEND*/
//CHKSM=9821AA686A03BCD97200E600B9FBA51A6C519E30
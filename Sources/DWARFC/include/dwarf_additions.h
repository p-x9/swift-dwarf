//
//  dwarf_additions.h
//  swift-dwarf
//
//  Created by p-x9 on 2025/04/27
//  
//

#ifndef dwarf_additions_h
#define dwarf_additions_h

#define DW_UT_compile 0x01
#define DW_UT_type 0x02
#define DW_UT_partial 0x03
#define DW_UT_skeleton 0x04
#define DW_UT_split_compile 0x05
#define DW_UT_split_type 0x06
#define DW_UT_lo_user 0x80
#define DW_UT_hi_user 0xff

#define DW_TAG_null                         0x0000 /* DWARF 2 */
#define DW_TAG_APPLE_property               0x4200 /* APPLE */
#define DW_TAG_LLVM_ptrauth_type            0x4300 /* LLVM */
#define DW_TAG_GHS_namespace                0x8004 /* GHS */
#define DW_TAG_GHS_using_namespace          0x8005 /* GHS */
#define DW_TAG_GHS_using_declaration        0x8006 /* GHS */
#define DW_TAG_GHS_template_templ_param     0x8007 /* GHS */
#define DW_TAG_UPC_shared_type              0x8765 /* UPC */
#define DW_TAG_UPC_strict_type              0x8766 /* UPC */
#define DW_TAG_UPC_relaxed                  0x8767 /* UPC */

#define DW_AT_GHS_namespace_alias                    0x806 /* GHS */
#define DW_AT_GHS_using_namespace                    0x807 /* GHS */
#define DW_AT_GHS_using_declaration                  0x808 /* GHS */
#define DW_AT_GHS_rsm                                0x2083 /* GHS */
#define DW_AT_GHS_frsm                               0x2085 /* GHS */
#define DW_AT_GHS_frames                             0x2086 /* GHS */
#define DW_AT_GHS_rso                                0x2087 /* GHS */
#define DW_AT_GHS_subcpu                             0x2092 /* GHS */
#define DW_AT_GHS_lbrace_line                        0x2093 /* GHS */
#define DW_AT_SUN_90_pointer                         0x222a /* SUN */
#define DW_AT_GO_kind                                0x2900 /* GO */
#define DW_AT_GO_key                                 0x2901 /* GO */
#define DW_AT_GO_elem                                0x2902 /* GO */
#define DW_AT_GO_embedded_field                      0x2903 /* GO */
#define DW_AT_GO_runtime_type                        0x2904 /* GO */
#define DW_AT_UPC_threads_scaled                     0x3210 /* UPC */
#define DW_AT_BORLAND_Delphi_return                  0x3b29 /* BORLAND */
#define DW_AT_LLVM_ptrauth_key                       0x3e04 /* LLVM */
#define DW_AT_LLVM_ptrauth_address_discriminated     0x3e05 /* LLVM */
#define DW_AT_LLVM_ptrauth_extra_discriminator       0x3e06 /* LLVM */
#define DW_AT_LLVM_ptrauth_isa_pointer               0x3e08 /* LLVM */
#define DW_AT_LLVM_ptrauth_authenticates_null_values 0x3e09 /* LLVM */
#define DW_AT_LLVM_ptrauth_authentication_mode       0x3e0a /* LLVM */
#define DW_AT_LLVM_num_extra_inhabitants             0x3e0b /* LLVM */
#define DW_AT_LLVM_stmt_sequence                     0x3e0c /* LLVM */
#define DW_AT_APPLE_enum_kind                        0x3ff1 /* APPLE */

#endif /* dwarf_additions_h */

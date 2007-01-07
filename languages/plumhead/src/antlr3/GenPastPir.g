// Copyright (C) 2006-2007, The Perl Foundation.
// $Id$

// Transform ANTLR PAST to PIR that sets up a PAST data structure
// let the Parrot Compiler Tools handle the execution.
// Jumpstarted by languages/bc/grammar/antlr_3/antlr_past2pir_past.g 

tree grammar GenPastPir;

options
{
  ASTLabelType = CommonTree;
  tokenVocab   = Plumhead;      // Token file is found because of '-lib' option
}


@header 
{
  import java.util.regex.*;
}

@members
{
  // used for generating unique register names
  public static int reg_num = 200;
}

gen_pir_past 
  : {
      System.out.println( 
          "#!/usr/bin/env parrot                                             \n"
        + "                                                                  \n"
        + "# Do not edit this file.                                          \n"
        + "# This file has been generated by GenPastPir.xsl                  \n"
        + "                                                                  \n"
        + ".sub 'php_init' :load :init                                       \n"
        + "                                                                  \n"
        + "  load_bytecode 'languages/plumhead/src/common/plumheadlib.pbc'   \n"
        + "  load_bytecode 'PAST-pm.pbc'                                     \n"
        + "  load_bytecode 'MIME/Base64.pbc'                                 \n"
        + "  load_bytecode 'dumper.pbc'                                      \n"
        + "  load_bytecode 'CGI/QueryHash.pbc'                               \n"
        + "                                                                  \n"
        + ".end                                                              \n"
        + "                                                                  \n"
        + ".sub plumhead :main                                               \n"
        + "                                                                  \n"
        + "    # look for subs in other namespaces                           \n"
        + "    .local pmc parse_get_sub, parse_post_sub   \n"
        + "    parse_get_sub  = get_global [ 'CGI'; 'QueryHash' ], 'parse_get'         \n"
        + "    parse_post_sub = get_global [ 'CGI'; 'QueryHash' ], 'parse_post'        \n"
        + "                                                                  \n"
        + "    # the superglobals                                            \n"
        + "    .local pmc superglobal_GET                                    \n"
        + "    ( superglobal_GET ) = parse_get_sub()                         \n"
        + "    set_global '_GET', superglobal_GET                            \n"
        + "                                                                  \n"
        + "    .local pmc superglobal_POST                                   \n"
        + "    ( superglobal_POST ) = parse_post_sub()                       \n"
        + "    set_global '_POST', superglobal_POST                          \n"
        + "                                                                  \n"
        + "    # The root node of PAST.                                      \n"
        + "    .local pmc past_node_id2244466                                \n"
        + "    past_node_id2244466  = new 'PAST::Block'                      \n"
        + "    past_node_id2244466.init('name' => 'plumhead_main')           \n"
        + "                                                                  \n"
        + "  # start of generic node                                         \n"
        + "  .local pmc past_stmts                                           \n"
        + "  past_stmts = new 'PAST::Stmts'                                  \n"
        + "                                                                  \n"
        + "  .sym pmc past_temp                                              \n"
        + "                                                                  \n"
      );
    }
    ^( PROGRAM node["past_stmts"]* )
    {
      System.out.println( 
          "                                                                  \n"
        + "                                                                  \n"
        + "  past_node_id2244466.'push'( past_stmts )               \n"
        + "  null past_stmts                                        \n"
        + "  # end of generic node                                           \n"
        + "                                                                  \n"
        + "                                                                  \n"
        + "                                                                  \n"
        + "    # '_dumper'(past_node_id2244466, 'past')                      \n"
        + "    # '_dumper'(superglobal_POST , 'superglobal_POST')            \n"
        + "    # '_dumper'(superglobal_GET , 'superglobal_GET')              \n"
        + "                                                                  \n"
        + "    # .local pmc post                                             \n"
        + "    # post = past_node_id2244466.'compile'( 'target' => 'post' )  \n"
        + "    # '_dumper'(post, 'post')                                     \n"
        + "                                                                  \n"
        + "    # .local pmc pir                                              \n"
        + "    # pir = past_node_id2244466.'compile'( 'target' => 'pir' )    \n"
        + "    # print pir                                                   \n"
        + "                                                                  \n"
        + "    .local pmc eval_past                                          \n"
        + "    eval_past = past_node_id2244466.'compile'( )                  \n"
        + "    eval_past()                                                   \n"
        + "    # '_dumper'(eval, 'eval')                                     \n"
        + "                                                                  \n"
        + ".end                                                              \n"
        + "                                                                  \n"
        + "                                                                  \n"
      );
    }
  ;

node[String reg_mother]
  : {
      System.out.println( 
          "  # start of ECHO node                                            \n"
        + "  .local pmc past_echo                                            \n"
        + "  past_echo = new 'PAST::Op'                                      \n"
        + "      past_echo.'attr'( 'name', 'echo', 1 )                       \n"
      );
    }
    ^( ECHO node["past_echo"] )
    {
      System.out.println( 
          "                                                                  \n"
        + "  " + $node.reg_mother + ".'push'( past_echo )                    \n"
        + "  null past_echo                                                  \n"
        + "  # end of ECHO node                                              \n"
      );
    }
  | STRING
    {
      String without_anno = $STRING.text;
      without_anno = without_anno.replace( "start_sea", "\"" );
      without_anno = without_anno.replace( "end_sea", "\"" );
      without_anno = without_anno.replace( "\n", "\\n" );
      System.out.println( 
          "                                                                  \n"
        + "  # start of STRING                                               \n"
        + "  past_temp = new 'PAST::Val'                                     \n"
        + "      past_temp.'attr'( 'name', " + without_anno + ", 1 )         \n"
        + "      past_temp.'attr'( 'ctype', 's~', 1 )                        \n"
        + "      past_temp.'attr'( 'vtype', '.String', 1 )                   \n"
        + "  " + $node.reg_mother + ".'push'( past_temp )                    \n"
        + "  null past_temp                                                  \n"
        + "  # end of STRING                                                 \n"
        + "                                                                  \n"
      );
    }
  | INTEGER
    {
      System.out.println( 
          "                                                                  \n"
        + "  # start of INTEGER                                              \n"
        + "  past_temp = new 'PAST::Val'                                     \n"
        + "      past_temp.'attr'( 'name', '" + $INTEGER.text + "', 1 )      \n"
        + "      past_temp.'attr'( 'ctype', 'i+', 1 )                        \n"
        + "      past_temp.'attr'( 'vtype', '.Integer', 1 )                  \n"
        + "  " + $node.reg_mother + ".'push'( past_temp )                    \n"
        + "  null past_temp                                                  \n"
        + "  # end of INTEGER                                                \n"
        + "                                                                  \n"
      );
    }
  | {
      reg_num++;
      String reg = "reg_" + reg_num;
      System.out.print( 
          "                                                                   \n"
        + "    # entering PLUS | MINUS | MUL_OP | REL_OP                      \n"
        + "      .sym pmc " + reg + "                                         \n"
        + "      " + reg + " = new 'PAST::Op'                                 \n"
      );
    }
    ^( infix=( PLUS | MINUS | MUL_OP | REL_OP ) node[reg] node[reg] )
    {
      // Todo. This is not nice, handl pirops in Plumhead.g
      String pirop = $infix.text;
      if      ( pirop.equals( "+" ) )  { pirop = "n_add"; }
      else if ( pirop.equals( "-" ) )  { pirop = "n_sub"; }
      else if ( pirop.equals( "*" ) )  { pirop = "n_mul"; }
      else if ( pirop.equals( "/" ) )  { pirop = "n_div"; }
      else if ( pirop.equals( "\%" ) ) { pirop = "n_mod"; }
      
      System.out.print( 
          "  " + reg + ".'attr'( 'pirop', '" + pirop + "' , 1 )               \n"
        + "  " + $node.reg_mother + ".'push'( " + reg + " )                   \n"
        + "      null " + reg + "                                             \n"
        + "    # leaving ( PLUS | MINUS | MUL | DIV )                         \n"
      );
    }
  | ^( FUNCTION LETTER )
    {
      // do nothing for now
    }
  | {
      System.out.print( 
          "                                                                   \n"
        + "  # entering 'assign'                                              \n"
        + "    reg_assign_lhs = new 'PAST::Exp'                               \n"
      );
    }
    ^( ASSIGN_OP ^(VAR LETTER) node["reg_assign_lhs"] )
    {
      // TODO: strip String
      System.out.print(     
          "                                                                   \n"
        + "    # entering 'ASSIGN_OP ^(VAR LETTER) node'                      \n"
        + "      .sym pmc past_op                                             \n"
        + "      past_op = new 'PAST::Op'                                     \n"
        + "      past_op.'op'( 'infix:=' )                                    \n"
        + "        .sym pmc past_var                                          \n"
        + "        past_var = new 'PAST::Var'                                 \n"
        + "        past_var.'varname'( '" + $LETTER.text + "' )               \n"
        + "        past_var.'vartype'( 'scalar' )                             \n"
        + "        past_var.'scope'( 'global' )                               \n"
        + "      past_op.'add_child'( past_var )                              \n"
        + "      past_op.'add_child'( reg_assign_lhs )                        \n"
        + "    " + $node.reg_mother + ".'add_child'( past_op )                \n"
        + "    # leaving  'ASSIGN_OP named_expression NUMBER'                 \n"
      );
    }
  | NUMBER
    {
      System.out.print(     
          "                                                                  \n"
        + "# entering 'NUMBER'                                               \n"
        + "past_temp = new 'PAST::Val'                                        \n"
        + "past_temp.value( " + $NUMBER.text + " )                            \n"
        + "past_temp.valtype( 'num' )                                         \n"
        + $node.reg_mother + ".'add_child'( past_temp )                       \n"
        + "null past_temp                                                     \n"
        + "# leaving 'NUMBER'                                                \n"
      );
    }
  | ^( VAR LETTER )
    {
      System.out.print( 
          "                                                                   \n"
        + " # entering '( VAR LETTER )                                        \n"
        + "    past_temp = new 'PAST::Var'                                     \n"
        + "    past_temp.'varname'( '" + $LETTER.text + "' )                   \n"
        + "    past_temp.'vartype'( 'scalar' )                                 \n"
        + "    past_temp.'scope'( 'global' )                                   \n"
        + "  " + $node.reg_mother + ".'add_child'( past_temp )                 \n"
        + "    null past_temp                                                  \n"
        + "  # leaving '(VAR LETTER)'                                         \n"
      );
    }
  | NEWLINE
    { 
      System.out.print(     
          "                                                                   \n"
        + "# entering 'NEWLINE'                                               \n"
        + "            past_temp = new 'PAST::Val'                            \n"
        + "            past_temp.value( '\\n' )                               \n"
        + "            past_temp.valtype( 'strqq' )                           \n"
        + "          " + $node.reg_mother + ".'add_child'( past_temp )        \n"
        + "          null past_temp                                           \n"
        + "# leaving 'NEWLINE'                                                \n"
      );
    }
  | {
      reg_num++;
      String reg_exp   = "reg_expression_" + reg_num;
      System.out.print( 
          "  # entering 'If node node                                         \n"
        + "      reg_if_op = new 'PAST::Op'                                   \n"
        + "      reg_if_op.'op'( 'if' )                                       \n"
        + "        .sym pmc " + reg_exp + "                                   \n"
        + "        " + reg_exp + " = new 'PAST::Exp'                          \n"
        + "                                                                   \n"
      );
    }
    ^( If node["reg_if_op"] node["reg_if_op"] )
    {
       // Create a node for If
      System.out.print( 
          "  # entering 'STMTS node*'                                         \n"
        + "  " + $node.reg_mother + ".'add_child'( reg_if_op )                \n"
        + "  # leaving 'If node node                                          \n"
      );
    }
  | {
      reg_num++;
      String reg_stmts = "reg_stmts_" + reg_num;
      System.out.print( 
          "        .sym pmc " + reg_stmts + "                                 \n"
        + "        " + reg_stmts + " = new 'PAST::Stmts'                      \n"
      );
    }
    ^( STMTS node[reg_stmts]* )
    {
       // Create a node for If
      System.out.print( 
          "  " + $node.reg_mother + ".'add_child'( " + reg_stmts + " )        \n"
        + "  # leaving 'STMTS node*'                                          \n"
      );
    }
  ;

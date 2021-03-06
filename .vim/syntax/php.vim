" Vim syntax file
" Language: php PHP 3/4/5
" Maintainer: Peter Hodge <toomuchphp-vim@yahoo.com>
" Last Change:  June 9, 2006
" URL: http://www.vim.org/scripts/script.php?script_id=1571
"
" Former Maintainer:  Debian VIM Maintainers <pkg-vim-maintainers@lists.alioth.debian.org>
" Former URL: http://svn.debian.org/wsvn/pkg-vim/trunk/runtime/syntax/php.vim?op=file&rev=0&sc=0
"
" Note: If you are using a colour terminal with dark background, you will probably find
"       the 'elflord' colorscheme is much better for PHP's syntax than the default
"       colourscheme, because elflord's colours will better highlight the break-points
"       (Statements) in your code.
"
" Options:  php_sql_query = 1  for SQL syntax highlighting inside strings
"           php_htmlInStrings = 1  for HTML syntax highlighting inside strings
"           php_baselib = 1  for highlighting baselib functions
"           php_asp_tags = 1  for highlighting ASP-style short tags
"           php_parent_error_close = 1  for highlighting parent error ] or )
"           php_parent_error_open = 1  for skipping an php end tag, if there exists an open ( or [ without a closing one
"           php_oldStyle = 1  for using old colorstyle
"           php_noShortTags = 1  don't sync <? ?> as php
"           php_folding = 1  for folding classes and functions
"           php_folding = 2  for folding all { } regions
"           php_sync_method = x
"                             x=-1 to sync by search ( default )
"                             x>0 to sync at least x lines backwards
"                             x=0 to sync from start
"
"       Added by Peter Hodge On June 9, 2006:
"           php_special_functions = 1|0 to highlight functions with abnormal behaviour
"           php_alt_comparisons = 1|0 to highlight comparison operators in an alternate colour
"           php_alt_assignByReference = 1|0 to highlight '= &' in an alternate colour
"
"           Note: these all default to 1 (On), so you would set them to '0' to turn them off.
"                 E.g., in your .vimrc or _vimrc file:
"                   let php_special_functions = 0
"                   let php_alt_comparisons = 0
"                   let php_alt_assignByReference = 0
"                 Unletting these variables will revert back to their default (On).
"
"
" Note:
" Setting php_folding=1 will match a closing } by comparing the indent
" before the class or function keyword with the indent of a matching }.
" Setting php_folding=2 will match all of pairs of {,} ( see known
" bugs ii )

" Known Bugs:
"  - setting  php_parent_error_close  on  and  php_parent_error_open  off
"    has these two leaks:
"     i) A closing ) or ] inside a string match to the last open ( or [
"        before the string, when the the closing ) or ] is on the same line
"        where the string started. In this case a following ) or ] after
"        the string would be highlighted as an error, what is incorrect.
"    ii) Same problem if you are setting php_folding = 2 with a closing
"        } inside an string on the first line of this string.
"
"  - A double-quoted string like this:
"      "$foo->someVar->someOtherVar->bar"
"    will highight '->someOtherVar->bar' as though they will be parsed
"    as object member variables, but PHP only recognizes the first
"    object member variable ($foo->someVar).
"
"

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

if !exists("main_syntax")
  let main_syntax = 'php'
endif

if version < 600
  unlet! php_folding
  if exists("php_sync_method") && !php_sync_method
    let php_sync_method=-1
  endif
  so <sfile>:p:h/html.vim
else
  runtime! syntax/html.vim
  unlet b:current_syntax
endif

" accept old options
if !exists("php_sync_method")
  if exists("php_minlines")
    let php_sync_method=php_minlines
  else
    let php_sync_method=-1
  endif
endif

if exists("php_parentError") && !exists("php_parent_error_open") && !exists("php_parent_error_close")
  let php_parent_error_close=1
  let php_parent_error_open=1
endif

syn cluster htmlPreproc add=phpRegion,phpRegionAsp,phpRegionSc

if version < 600
  syn include @sqlTop <sfile>:p:h/sql.vim
else
  syn include @sqlTop syntax/sql.vim
endif
syn sync clear
unlet b:current_syntax
syn cluster sqlTop remove=sqlString,sqlComment
if exists( "php_sql_query")
  syn cluster phpAddStrings contains=@sqlTop
endif

if exists( "php_htmlInStrings")
  syn cluster phpAddStrings add=@htmlTop
endif

syn case match

" Env Variables
syn keyword phpEnvVar GATEWAY_INTERFACE SERVER_NAME SERVER_SOFTWARE SERVER_PROTOCOL REQUEST_METHOD QUERY_STRING DOCUMENT_ROOT HTTP_ACCEPT HTTP_ACCEPT_CHARSET HTTP_ENCODING HTTP_ACCEPT_LANGUAGE HTTP_CONNECTION HTTP_HOST HTTP_REFERER HTTP_USER_AGENT REMOTE_ADDR REMOTE_PORT SCRIPT_FILENAME SERVER_ADMIN SERVER_PORT SERVER_SIGNATURE PATH_TRANSLATED SCRIPT_NAME REQUEST_URI contained

" Internal Variables
syn keyword phpIntVar GLOBALS PHP_ERRMSG PHP_SELF HTTP_GET_VARS HTTP_POST_VARS HTTP_COOKIE_VARS HTTP_POST_FILES HTTP_ENV_VARS HTTP_SERVER_VARS HTTP_SESSION_VARS HTTP_RAW_POST_DATA HTTP_STATE_VARS _GET _POST _COOKIE _FILES _SERVER _ENV _SERVER _REQUEST _SESSION  contained

" Constants
syn keyword phpCoreConstant PHP_VERSION PHP_OS DEFAULT_INCLUDE_PATH PEAR_INSTALL_DIR PEAR_EXTENSION_DIR PHP_EXTENSION_DIR PHP_BINDIR PHP_LIBDIR PHP_DATADIR PHP_SYSCONFDIR PHP_LOCALSTATEDIR PHP_CONFIG_FILE_PATH PHP_OUTPUT_HANDLER_START PHP_OUTPUT_HANDLER_CONT PHP_OUTPUT_HANDLER_END E_ERROR E_WARNING E_PARSE E_NOTICE E_CORE_ERROR E_CORE_WARNING E_COMPILE_ERROR E_COMPILE_WARNING E_USER_ERROR E_USER_WARNING E_USER_NOTICE E_ALL  contained

syn keyword phpFunctions  assertArrayHasKey assertClassHasAttribute assertClassHasStaticAttribute assertContains assertContainsOnly assertCount assertEmpty assertEqualXMLStructure assertEquals assertFalse assertFileEquals assertFileExists assertGreaterThan assertGreaterThanOrEqual assertInstanceOf assertInternalType assertLessThan assertLessThanOrEqual assertNull assertObjectHasAttribute assertRegExp assertStringMatchesFormat assertStringMatchesFormatFile assertSame assertSelectCount assertSelectEquals assertSelectRegExp assertStringEndsWith assertStringEqualsFile assertStringStartsWith assertTag assertThat assertTrue assertXmlFileEqualsXmlFile assertXmlStringEqualsXmlFile assertXmlStringEqualsXmlString contained
syn keyword phpFunctions  attribute anything arrayHasKey 'contains' containsOnly containsOnlyInstanceOf equalTo attributeEqualTo fileExists greaterThan greaterThanOrEqual classHasAttribute classHasStaticAttribute hasAttribute identicalTo isTrue isType lessThan lessThanOrEqual logicalAnd logicalNot logicalOr logicalXor matchesRegularExpression stringContains stringEndsWith stringStartsWith contained

syn case ignore

syn keyword phpConstant  __LINE__ __FILE__ __DIR__ __FUNCTION__ __METHOD__ __CLASS__ __NAMESPACE__ contained


" Function and Methods ripped from php_manual_de.tar.gz Jan 2003
syn keyword phpFunctions  apache_child_terminate apache_get_modules apache_get_version apache_getenv apache_lookup_uri apache_note apache_request_headers apache_response_headers apache_setenv ascii2ebcdic ebcdic2ascii getallheaders virtual contained
syn keyword phpFunctions  array_change_key_case array_chunk array_combine array_count_values array_diff_assoc array_diff_uassoc array_diff array_fill array_filter array_flip array_intersect_assoc array_intersect array_key_exists array_keys array_map array_merge_recursive array_merge array_multisort array_pad array_pop array_push array_rand array_reduce array_reverse array_search array_shift array_slice array_splice array_sum array_udiff_assoc array_udiff_uassoc array_udiff array_unique array_unshift array_values array_walk array arsort asort compact count current each end extract in_array key krsort ksort list natcasesort natsort next pos prev range reset rsort shuffle sizeof sort uasort uksort usort contained
syn keyword phpFunctions  iterator_apply iterator_to_array iterator_count spl_object_hash spl_autoloader_register contained
syn keyword phpFunctions  aspell_check aspell_new aspell_suggest  contained
syn keyword phpFunctions  bcadd bccomp bcdiv bcmod bcmul bcpow bcpowmod bcscale bcsqrt bcsub  contained
syn keyword phpFunctions  bzclose bzcompress bzdecompress bzerrno bzerror bzerrstr bzflush bzopen bzread bzwrite  contained
syn keyword phpFunctions  cal_days_in_month cal_from_jd cal_info cal_to_jd easter_date easter_days frenchtojd gregoriantojd jddayofweek jdmonthname jdtofrench jdtogregorian jdtojewish jdtojulian jdtounix jewishtojd juliantojd unixtojd  contained
syn keyword phpFunctions  ccvs_add ccvs_auth ccvs_command ccvs_count ccvs_delete ccvs_done ccvs_init ccvs_lookup ccvs_new ccvs_report ccvs_return ccvs_reverse ccvs_sale ccvs_status ccvs_textvalue ccvs_void contained
syn keyword phpFunctions  call_user_method_array call_user_method class_exists get_class_methods get_class_vars get_class get_declared_classes get_object_vars get_parent_class is_a is_subclass_of method_exists contained
syn keyword phpFunctions  com VARIANT com_addref com_get com_invoke com_isenum com_load_typelib com_load com_propget com_propput com_propset com_release com_set  contained
syn keyword phpFunctions  crack_check crack_closedict crack_getlastmessage crack_opendict contained
syn keyword phpFunctions  ctype_alnum ctype_alpha ctype_cntrl ctype_digit ctype_graph ctype_lower ctype_print ctype_punct ctype_space ctype_upper ctype_xdigit  contained
syn keyword phpFunctions  curl_close curl_errno curl_error curl_exec curl_getinfo curl_init curl_multi_add_handle curl_multi_close curl_multi_exec curl_multi_getcontent curl_multi_info_read curl_multi_init curl_multi_remove_handle curl_multi_select curl_setopt curl_setopt_array curl_version curl_multi_setopt contained
syn keyword phpFunctions  cybercash_base64_decode cybercash_base64_encode cybercash_decr cybercash_encr contained
syn keyword phpFunctions  cyrus_authenticate cyrus_bind cyrus_close cyrus_connect cyrus_query cyrus_unbind  contained
syn keyword phpFunctions  checkdate date getdate gettimeofday gmdate gmmktime gmstrftime localtime microtime mktime strftime strtotime time date_create date_add date_date_set date_diff date_format date_get_last_errors date_interval_create_from_date_string date_interval_format date_isodate_set date_modify date_offset_get date_parse_from_format date_parse date_sub date_sun_info date_sunrise date_sunset date_time_set date_timestamp_get date_timestamp_set date_timezone_get date_timezone_set contained
syn keyword phpFunctions  chdir chroot dir closedir getcwd opendir readdir rewinddir scandir  contained
syn keyword phpFunctions  domxml_new_doc domxml_open_file domxml_open_mem domxml_version domxml_xmltree domxml_xslt_stylesheet_doc domxml_xslt_stylesheet_file domxml_xslt_stylesheet xpath_eval_expression xpath_eval xpath_new_context xptr_eval xptr_new_context contained
syn keyword phpMethods  name specified value create_attribute create_cdata_section create_comment create_element_ns create_element create_entity_reference create_processing_instruction create_text_node doctype document_element dump_file dump_mem get_element_by_id get_elements_by_tagname html_dump_mem xinclude entities internal_subset name notations public_id system_id get_attribute_node get_attribute get_elements_by_tagname has_attribute remove_attribute set_attribute tagname add_namespace append_child append_sibling attributes child_nodes clone_node dump_node first_child get_content has_attributes has_child_nodes insert_before is_blank_node last_child next_sibling node_name node_type node_value owner_document parent_node prefix previous_sibling remove_child replace_child replace_node set_content set_name set_namespace unlink_node data target process result_dump_file result_dump_mem contained
syn keyword phpFunctions  dotnet_load contained
syn keyword phpFunctions  debug_backtrace debug_print_backtrace error_log error_reporting restore_error_handler set_error_handler trigger_error user_error  contained
syn keyword phpFunctions  escapeshellarg escapeshellcmd exec passthru proc_close proc_get_status proc_nice proc_open proc_terminate shell_exec system contained
syn keyword phpFunctions  fam_cancel_monitor fam_close fam_monitor_collection fam_monitor_directory fam_monitor_file fam_next_event fam_open fam_pending fam_resume_monitor fam_suspend_monitor contained
syn keyword phpFunctions  filepro_fieldcount filepro_fieldname filepro_fieldtype filepro_fieldwidth filepro_retrieve filepro_rowcount filepro contained
syn keyword phpFunctions  basename chgrp chmod chown clearstatcache copy delete dirname disk_free_space disk_total_space diskfreespace fclose feof fflush fgetc fgetcsv fgets fgetss file_exists file_get_contents file_put_contents file fileatime filectime filegroup fileinode filemtime fileowner fileperms filesize filetype flock fnmatch fopen fpassthru fputs fread fscanf fseek fstat ftell ftruncate fwrite glob is_dir is_executable is_file is_link is_readable is_uploaded_file is_writable is_writeable link linkinfo lstat mkdir move_uploaded_file parse_ini_file pathinfo pclose popen readfile readlink realpath rename rewind rmdir set_file_buffer stat symlink tempnam tmpfile touch umask unlink  contained
syn keyword phpFunctions  fribidi_log2vis contained
syn keyword phpFunctions  call_user_func_array call_user_func create_function func_get_arg func_get_args func_num_args function_exists get_defined_functions register_shutdown_function register_tick_function unregister_tick_function contained
syn keyword phpFunctions  bind_textdomain_codeset bindtextdomain dcgettext dcngettext dgettext dngettext gettext ngettext textdomain  contained
syn keyword phpFunctions  header headers_list headers_sent setcookie  contained
syn keyword phpMethods  key langdepvalue value values checkin checkout children mimetype read content copy dbstat dcstat dstanchors dstofsrcanchors count reason find ftstat hwstat identify info insert insertanchor insertcollection insertdocument link lock move assign attreditable count insert remove title value object objectbyanchor parents description type remove replace setcommitedversion srcanchors srcsofdst unlock user userlist contained
syn keyword phpFunctions  hw_Array2Objrec hw_changeobject hw_Children hw_ChildrenObj hw_Close hw_Connect hw_connection_info hw_cp hw_Deleteobject hw_DocByAnchor hw_DocByAnchorObj hw_Document_Attributes hw_Document_BodyTag hw_Document_Content hw_Document_SetContent hw_Document_Size hw_dummy hw_EditText hw_Error hw_ErrorMsg hw_Free_Document hw_GetAnchors hw_GetAnchorsObj hw_GetAndLock hw_GetChildColl hw_GetChildCollObj hw_GetChildDocColl hw_GetChildDocCollObj hw_GetObject hw_GetObjectByQuery hw_GetObjectByQueryColl hw_GetObjectByQueryCollObj hw_GetObjectByQueryObj hw_GetParents hw_GetParentsObj hw_getrellink hw_GetRemote hw_getremotechildren hw_GetSrcByDestObj hw_GetText hw_getusername hw_Identify hw_InCollections hw_Info hw_InsColl hw_InsDoc hw_insertanchors hw_InsertDocument hw_InsertObject hw_mapid hw_Modifyobject hw_mv hw_New_Document hw_objrec2array hw_Output_Document hw_pConnect hw_PipeDocument hw_Root hw_setlinkroot hw_stat hw_Unlock hw_Who contained
syn keyword phpFunctions  iconv_get_encoding iconv_mime_decode_headers iconv_mime_decode iconv_mime_encode iconv_set_encoding iconv_strlen iconv_strpos iconv_strrpos iconv_substr iconv ob_iconv_handler contained
syn keyword phpFunctions  assert_options assert dl extension_loaded get_cfg_var get_current_user get_defined_constants get_extension_funcs get_include_path get_included_files get_loaded_extensions get_magic_quotes_gpc get_magic_quotes_runtime get_required_files getenv getlastmod getmygid getmyinode getmypid getmyuid getopt getrusage ini_alter ini_get_all ini_get ini_restore ini_set main memory_get_usage php_ini_scanned_files php_logo_guid php_sapi_name php_uname phpcredits phpinfo phpversion putenv restore_include_path set_include_path set_magic_quotes_runtime set_time_limit version_compare zend_logo_guid zend_version contained
syn keyword phpFunctions  abs acos acosh asin asinh atan2 atan atanh base_convert bindec ceil cos cosh decbin dechex decoct deg2rad exp expm1 floor fmod getrandmax hexdec hypot is_finite is_infinite is_nan lcg_value log10 log1p log max min mt_getrandmax mt_rand mt_srand octdec pi pow rad2deg rand round sin sinh sqrt srand tan tanh  contained
syn keyword phpFunctions  mb_convert_case mb_convert_encoding mb_convert_kana mb_convert_variables mb_decode_mimeheader mb_decode_numericentity mb_detect_encoding mb_detect_order mb_encode_mimeheader mb_encode_numericentity mb_ereg_match mb_ereg_replace mb_ereg_search_getpos mb_ereg_search_getregs mb_ereg_search_init mb_ereg_search_pos mb_ereg_search_regs mb_ereg_search_setpos mb_ereg_search mb_ereg mb_eregi_replace mb_eregi mb_get_info mb_http_input mb_http_output mb_internal_encoding mb_language mb_output_handler mb_parse_str mb_preferred_mime_name mb_regex_encoding mb_regex_set_options mb_send_mail mb_split mb_strcut mb_strimwidth mb_strlen mb_strpos mb_strrpos mb_strtolower mb_strtoupper mb_strwidth mb_substitute_character mb_substr_count mb_substr  contained
syn keyword phpFunctions  mcal_append_event mcal_close mcal_create_calendar mcal_date_compare mcal_date_valid mcal_day_of_week mcal_day_of_year mcal_days_in_month mcal_delete_calendar mcal_delete_event mcal_event_add_attribute mcal_event_init mcal_event_set_alarm mcal_event_set_category mcal_event_set_class mcal_event_set_description mcal_event_set_end mcal_event_set_recur_daily mcal_event_set_recur_monthly_mday mcal_event_set_recur_monthly_wday mcal_event_set_recur_none mcal_event_set_recur_weekly mcal_event_set_recur_yearly mcal_event_set_start mcal_event_set_title mcal_expunge mcal_fetch_current_stream_event mcal_fetch_event mcal_is_leap_year mcal_list_alarms mcal_list_events mcal_next_recurrence mcal_open mcal_popen mcal_rename_calendar mcal_reopen mcal_snooze mcal_store_event mcal_time_valid mcal_week_of_year contained
syn keyword phpFunctions  mcrypt_cbc mcrypt_cfb mcrypt_create_iv mcrypt_decrypt mcrypt_ecb mcrypt_enc_get_algorithms_name mcrypt_enc_get_block_size mcrypt_enc_get_iv_size mcrypt_enc_get_key_size mcrypt_enc_get_modes_name mcrypt_enc_get_supported_key_sizes mcrypt_enc_is_block_algorithm_mode mcrypt_enc_is_block_algorithm mcrypt_enc_is_block_mode mcrypt_enc_self_test mcrypt_encrypt mcrypt_generic_deinit mcrypt_generic_end mcrypt_generic_init mcrypt_generic mcrypt_get_block_size mcrypt_get_cipher_name mcrypt_get_iv_size mcrypt_get_key_size mcrypt_list_algorithms mcrypt_list_modes mcrypt_module_close mcrypt_module_get_algo_block_size mcrypt_module_get_algo_key_size mcrypt_module_get_supported_key_sizes mcrypt_module_is_block_algorithm_mode mcrypt_module_is_block_algorithm mcrypt_module_is_block_mode mcrypt_module_open mcrypt_module_self_test mcrypt_ofb mdecrypt_generic  contained
syn keyword phpFunctions  mhash_count mhash_get_block_size mhash_get_hash_name mhash_keygen_s2k mhash contained
syn keyword phpFunctions  mime_content_type contained
syn keyword phpFunctions  connection_aborted connection_status connection_timeout constant define defined die eval exit get_browser highlight_file highlight_string ignore_user_abort pack show_source sleep uniqid unpack usleep contained
"syn keyword phpFunctions  udm_add_search_limit udm_alloc_agent udm_api_version udm_cat_list udm_cat_path udm_check_charset udm_check_stored udm_clear_search_limits udm_close_stored udm_crc32 udm_errno udm_error udm_find udm_free_agent udm_free_ispell_data udm_free_res udm_get_doc_count udm_get_res_field udm_get_res_param udm_load_ispell_data udm_open_stored udm_set_agent_param contained
"syn keyword phpFunctions  msession_connect msession_count msession_create msession_destroy msession_disconnect msession_find msession_get_array msession_get msession_getdata msession_inc msession_list msession_listvar msession_lock msession_plugin msession_randstr msession_set_array msession_set msession_setdata msession_timeout msession_uniq msession_unlock  contained
"syn keyword phpFunctions  msql_affected_rows msql_close msql_connect msql_create_db msql_createdb msql_data_seek msql_dbname msql_drop_db msql_dropdb msql_error msql_fetch_array msql_fetch_field msql_fetch_object msql_fetch_row msql_field_seek msql_fieldflags msql_fieldlen msql_fieldname msql_fieldtable msql_fieldtype msql_free_result msql_freeresult msql_list_dbs msql_list_fields msql_list_tables msql_listdbs msql_listfields msql_listtables msql_num_fields msql_num_rows msql_numfields msql_numrows msql_pconnect msql_query msql_regcase msql_result msql_select_db msql_selectdb msql_tablename msql  contained
"syn keyword phpFunctions  mssql_bind mssql_close mssql_connect mssql_data_seek mssql_execute mssql_fetch_array mssql_fetch_assoc mssql_fetch_batch mssql_fetch_field mssql_fetch_object mssql_fetch_row mssql_field_length mssql_field_name mssql_field_seek mssql_field_type mssql_free_result mssql_free_statement mssql_get_last_message mssql_guid_string mssql_init mssql_min_error_severity mssql_min_message_severity mssql_next_result mssql_num_fields mssql_num_rows mssql_pconnect mssql_query mssql_result mssql_rows_affected mssql_select_db  contained
"syn keyword phpFunctions  muscat_close muscat_get muscat_give muscat_setup_net muscat_setup contained
"syn keyword phpFunctions  mysql_affected_rows mysql_change_user mysql_client_encoding mysql_close mysql_connect mysql_create_db mysql_data_seek mysql_db_name mysql_db_query mysql_drop_db mysql_errno mysql_error mysql_escape_string mysql_fetch_array mysql_fetch_assoc mysql_fetch_field mysql_fetch_lengths mysql_fetch_object mysql_fetch_row mysql_field_flags mysql_field_len mysql_field_name mysql_field_seek mysql_field_table mysql_field_type mysql_free_result mysql_get_client_info mysql_get_host_info mysql_get_proto_info mysql_get_server_info mysql_info mysql_insert_id mysql_list_dbs mysql_list_fields mysql_list_processes mysql_list_tables mysql_num_fields mysql_num_rows mysql_pconnect mysql_ping mysql_query mysql_real_escape_string mysql_result mysql_select_db mysql_stat mysql_tablename mysql_thread_id mysql_unbuffered_query  contained
syn keyword phpFunctions  mysqli_affected_rows mysqli_autocommit mysqli_bind_param mysqli_bind_result mysqli_change_user mysqli_character_set_name mysqli_close mysqli_commit mysqli_connect mysqli_data_seek mysqli_debug mysqli_disable_reads_from_master mysqli_disable_rpl_parse mysqli_dump_debug_info mysqli_enable_reads_from_master mysqli_enable_rpl_parse mysqli_errno mysqli_error mysqli_execute mysqli_fetch_array mysqli_fetch_assoc mysqli_fetch_field_direct mysqli_fetch_field mysqli_fetch_fields mysqli_fetch_lengths mysqli_fetch_object mysqli_fetch_row mysqli_fetch mysqli_field_count mysqli_field_seek mysqli_field_tell mysqli_free_result mysqli_get_client_info mysqli_get_host_info mysqli_get_proto_info mysqli_get_server_info mysqli_get_server_version mysqli_info mysqli_init mysqli_insert_id mysqli_kill mysqli_master_query mysqli_num_fields mysqli_num_rows mysqli_options mysqli_param_count mysqli_ping mysqli_prepare_result mysqli_prepare mysqli_profiler mysqli_query mysqli_read_query_result mysqli_real_connect mysqli_real_escape_string mysqli_real_query mysqli_reload mysqli_rollback mysqli_rpl_parse_enabled mysqli_rpl_probe mysqli_rpl_query_type mysqli_select_db mysqli_send_long_data mysqli_send_query mysqli_slave_query mysqli_ssl_set mysqli_stat mysqli_stmt_affected_rows mysqli_stmt_close mysqli_stmt_errno mysqli_stmt_error mysqli_stmt_store_result mysqli_store_result mysqli_thread_id mysqli_thread_safe mysqli_use_result mysqli_warning_count  contained
syn keyword phpFunctions  checkdnsrr closelog debugger_off debugger_on define_syslog_variables dns_check_record dns_get_mx dns_get_record fsockopen gethostbyaddr gethostbyname gethostbynamel getmxrr getprotobyname getprotobynumber getservbyname getservbyport ip2long long2ip openlog pfsockopen socket_get_status socket_set_blocking socket_set_timeout syslog contained
syn keyword phpFunctions  openssl_csr_export_to_file openssl_csr_export openssl_csr_new openssl_csr_sign openssl_error_string openssl_free_key openssl_get_privatekey openssl_get_publickey openssl_open openssl_pkcs7_decrypt openssl_pkcs7_encrypt openssl_pkcs7_sign openssl_pkcs7_verify openssl_pkey_export_to_file openssl_pkey_export openssl_pkey_get_private openssl_pkey_get_public openssl_pkey_new openssl_private_decrypt openssl_private_encrypt openssl_public_decrypt openssl_public_encrypt openssl_seal openssl_sign openssl_verify openssl_x509_check_private_key openssl_x509_checkpurpose openssl_x509_export_to_file openssl_x509_export openssl_x509_free openssl_x509_parse openssl_x509_read contained
syn keyword phpFunctions  flush ob_clean ob_end_clean ob_end_flush ob_flush ob_get_clean ob_get_contents ob_get_flush ob_get_length ob_get_level ob_get_status ob_gzhandler ob_implicit_flush ob_list_handlers ob_start output_add_rewrite_var output_reset_rewrite_vars  contained
syn keyword phpFunctions  pcntl_exec pcntl_fork pcntl_signal pcntl_waitpid pcntl_wexitstatus pcntl_wifexited pcntl_wifsignaled pcntl_wifstopped pcntl_wstopsig pcntl_wtermsig contained
syn keyword phpFunctions  preg_grep preg_match_all preg_match preg_quote preg_replace_callback preg_replace preg_split  contained
syn keyword phpFunctions  recode_file recode_string recode  contained
syn keyword phpFunctions  ftok msg_get_queue msg_receive msg_remove_queue msg_send msg_set_queue msg_stat_queue sem_acquire sem_get sem_release sem_remove shm_attach shm_detach shm_get_var shm_put_var shm_remove_var shm_remove  contained
syn keyword phpFunctions  session_cache_expire session_cache_limiter session_decode session_destroy session_encode session_get_cookie_params session_id session_is_registered session_module_name session_name session_regenerate_id session_register session_save_path session_set_cookie_params session_set_save_handler session_start session_unregister session_unset session_write_close contained
syn keyword phpFunctions  socket_accept socket_bind socket_clear_error socket_close socket_connect socket_create_listen socket_create_pair socket_create socket_get_option socket_getpeername socket_getsockname socket_iovec_add socket_iovec_alloc socket_iovec_delete socket_iovec_fetch socket_iovec_free socket_iovec_set socket_last_error socket_listen socket_read socket_readv socket_recv socket_recvfrom socket_recvmsg socket_select socket_send socket_sendmsg socket_sendto socket_set_block socket_set_nonblock socket_set_option socket_shutdown socket_strerror socket_write socket_writev contained
syn keyword phpFunctions  sqlite_array_query sqlite_busy_timeout sqlite_changes sqlite_close sqlite_column sqlite_create_aggregate sqlite_create_function sqlite_current sqlite_error_string sqlite_escape_string sqlite_fetch_array sqlite_fetch_single sqlite_fetch_string sqlite_field_name sqlite_has_more sqlite_last_error sqlite_last_insert_rowid sqlite_libencoding sqlite_libversion sqlite_next sqlite_num_fields sqlite_num_rows sqlite_open sqlite_popen sqlite_query sqlite_rewind sqlite_seek sqlite_udf_decode_binary sqlite_udf_encode_binary sqlite_unbuffered_query  contained
syn keyword phpFunctions  stream_context_create stream_context_get_options stream_context_set_option stream_context_set_params stream_copy_to_stream stream_filter_append stream_filter_prepend stream_filter_register stream_get_contents stream_get_filters stream_get_line stream_get_meta_data stream_get_transports stream_get_wrappers stream_register_wrapper stream_select stream_set_blocking stream_set_timeout stream_set_write_buffer stream_socket_accept stream_socket_client stream_socket_get_name stream_socket_recvfrom stream_socket_sendto stream_socket_server stream_wrapper_register contained
syn keyword phpFunctions  addcslashes addslashes bin2hex chop chr chunk_split convert_cyr_string count_chars crc32 crypt explode fprintf get_html_translation_table hebrev hebrevc html_entity_decode htmlentities htmlspecialchars implode join levenshtein localeconv ltrim md5_file md5 metaphone money_format nl_langinfo nl2br number_format ord parse_str print printf quoted_printable_decode quotemeta rtrim setlocale sha1_file sha1 similar_text soundex sprintf sscanf str_ireplace str_pad str_repeat str_replace str_rot13 str_shuffle str_split str_word_count strcasecmp strchr strcmp strcoll strcspn strip_tags stripcslashes stripos stripslashes stristr strlen strnatcasecmp strnatcmp strncasecmp strncmp strpos strrchr strrev strripos strrpos strspn strstr strtok strtolower strtoupper strtr substr_compare substr_count substr_replace substr trim ucfirst ucwords vprintf vsprintf wordwrap contained
syn keyword phpFunctions  tidy_access_count tidy_clean_repair tidy_config_count tidy_diagnose tidy_error_count tidy_get_body tidy_get_config tidy_get_error_buffer tidy_get_head tidy_get_html_ver tidy_get_html tidy_get_output tidy_get_release tidy_get_root tidy_get_status tidy_getopt tidy_is_xhtml tidy_load_config tidy_parse_file tidy_parse_string tidy_repair_file tidy_repair_string tidy_reset_config tidy_save_config tidy_set_encoding tidy_setopt tidy_warning_count  contained
syn keyword phpMethods  attributes children get_attr get_nodes has_children has_siblings is_asp is_comment is_html is_jsp is_jste is_text is_xhtml is_xml next prev tidy_node contained
syn keyword phpFunctions  token_get_all token_name  contained
syn keyword phpFunctions  base64_decode base64_encode get_meta_tags http_build_query parse_url rawurldecode rawurlencode urldecode urlencode  contained
syn keyword phpFunctions  doubleval empty floatval get_defined_vars get_resource_type gettype import_request_variables intval is_array is_bool is_callable is_double is_float is_int is_integer is_long is_null is_numeric is_object is_real is_resource is_scalar is_string isset print_r serialize settype strval unserialize unset var_dump var_export contained
syn keyword phpFunctions  vpopmail_add_alias_domain_ex vpopmail_add_alias_domain vpopmail_add_domain_ex vpopmail_add_domain vpopmail_add_user vpopmail_alias_add vpopmail_alias_del_domain vpopmail_alias_del vpopmail_alias_get_all vpopmail_alias_get vpopmail_auth_user vpopmail_del_domain_ex vpopmail_del_domain vpopmail_del_user vpopmail_error vpopmail_passwd vpopmail_set_user_quota  contained
syn keyword phpFunctions  utf8_decode utf8_encode xml_error_string xml_get_current_byte_index xml_get_current_column_number xml_get_current_line_number xml_get_error_code xml_parse_into_struct xml_parse xml_parser_create_ns xml_parser_create xml_parser_free xml_parser_get_option xml_parser_set_option xml_set_character_data_handler xml_set_default_handler xml_set_element_handler xml_set_end_namespace_decl_handler xml_set_external_entity_ref_handler xml_set_notation_decl_handler xml_set_object xml_set_processing_instruction_handler xml_set_start_namespace_decl_handler xml_set_unparsed_entity_decl_handler contained
syn keyword phpFunctions  zip_close zip_entry_close zip_entry_compressedsize zip_entry_compressionmethod zip_entry_filesize zip_entry_name zip_entry_open zip_entry_read zip_open zip_read  contained
syn keyword phpFunctions  gzclose gzcompress gzdeflate gzencode gzeof gzfile gzgetc gzgets gzgetss gzinflate gzopen gzpassthru gzputs gzread gzrewind gzseek gztell gzuncompress gzwrite readgzfile zlib_get_coding_type  contained

if exists( "php_baselib" )
  syn keyword phpMethods  query next_record num_rows affected_rows nf f p np num_fields haltmsg seek link_id query_id metadata table_names nextid connect halt free register unregister is_registered delete url purl self_url pself_url hidden_session add_query padd_query reimport_get_vars reimport_post_vars reimport_cookie_vars set_container set_tokenname release_token put_headers get_id get_id put_id freeze thaw gc reimport_any_vars start url purl login_if is_authenticated auth_preauth auth_loginform auth_validatelogin auth_refreshlogin auth_registerform auth_doregister start check have_perm permsum perm_invalid contained
  syn keyword phpFunctions  page_open page_close sess_load sess_save  contained
endif

" Conditional
syn keyword phpConditional  declare else enddeclare endswitch elseif endif if switch contained

" Repeat
syn keyword phpRepeat as do endfor endforeach endwhile for foreach while  contained

" Repeat
syn keyword phpLabel  case default switch contained

" Statement
syn keyword phpStatement  return break continue exit yield contained

" Keyword
syn keyword phpKeyword  var const contained

" Type
syn keyword phpType bool[ean] int[eger] real double float string array object NULL  contained

" Structure
syn keyword phpStructure  extends implements instanceof parent self use trait namespace contained

" Operator
syn match phpOperator "[-=+%^&|*!.~?:\\]" contained display
syn match phpOperator "[-+*/%^&|.]="  contained display
syn match phpOperator "/[^*/]"me=e-1  contained display
syn match phpOperator "\$"  contained display
syn match phpOperator "&&\|\<and\>" contained display
syn match phpOperator "||\|\<x\=or\>" contained display
syn match phpRelation "[!=<>]=" contained display
syn match phpRelation "[<>]"  contained display
syn match phpMemberSelector "->"  contained display
syn match phpVarSelector  "\$"  contained display

" Identifier
syn match phpIdentifier "$\h\w*"  contained contains=phpEnvVar,phpIntVar,phpVarSelector display
syn match phpIdentifierSimply "${\h\w*}"  contains=phpOperator,phpParent  contained display
syn region  phpIdentifierComplex  matchgroup=phpParent start="{\$"rs=e-1 end="}"  contains=phpIdentifier,phpMemberSelector,phpVarSelector,phpIdentifierComplexP contained extend
syn region  phpIdentifierComplexP matchgroup=phpParent start="\[" end="]" contains=@phpClInside contained

" Methoden
syn match phpMethodsVar "->\h\w*" contained contains=phpMethods,phpMemberSelector display

" Include
syn keyword phpInclude  include require include_once require_once contained

" Peter Hodge - added 'clone' keyword
" Define
syn keyword phpDefine new clone contained

" Boolean
syn keyword phpBoolean  true false  contained

" Number
syn match phpNumber "-\=\<\d\+\>" contained display
syn match phpNumber "\<0x\x\{1,8}\>"  contained display

" Float
syn match phpFloat  "\(-\=\<\d+\|-\=\)\.\d\+\>" contained display

" SpecialChar
syn match phpSpecialChar  "\\[abcfnrtyv\\]" contained display
syn match phpSpecialChar  "\\\d\{3}"  contained contains=phpOctalError display
syn match phpSpecialChar  "\\x\x\{2}" contained display

" Error
syn match phpOctalError "[89]"  contained display
if exists("php_parent_error_close")
  syn match phpParentError  "[)\]}]"  contained display
endif

" Todo
syn keyword phpTodo todo fixme xxx  contained
syn match  phpTodo         contained "@\(api\|access\|author\|category\|copyright\|deprecated\|example\|filesource\|global\|ignore\|internal\|license\|link\|method\|name\|package\|param\|property\|return\|see\|since\|todo\|tutorial\|throws\|uses\|usedby\|version\)\>"

" Comment
if exists("php_parent_error_open")
  syn region  phpComment  start="/\*" end="\*/" contained contains=phpTodo
else
  syn region  phpComment  start="/\*" end="\*/" contained contains=phpTodo extend
endif
if version >= 600
  syn match phpComment  "#.\{-}\(?>\|$\)\@="  contained contains=phpTodo
  syn match phpComment  "//.\{-}\(?>\|$\)\@=" contained contains=phpTodo
else
  syn match phpComment  "#.\{-}$" contained contains=phpTodo
  syn match phpComment  "#.\{-}?>"me=e-2  contained contains=phpTodo
  syn match phpComment  "//.\{-}$"  contained contains=phpTodo
  syn match phpComment  "//.\{-}?>"me=e-2 contained contains=phpTodo
endif

" String
if exists("php_parent_error_open")
  syn region  phpStringDouble matchgroup=None start=+"+ skip=+\\\\\|\\"+ end=+"+  contains=@phpAddStrings,phpIdentifier,phpSpecialChar,phpIdentifierSimply,phpIdentifierComplex contained keepend
  syn region  phpBacktick matchgroup=None start=+`+ skip=+\\\\\|\\"+ end=+`+  contains=@phpAddStrings,phpIdentifier,phpSpecialChar,phpIdentifierSimply,phpIdentifierComplex contained keepend
  syn region  phpStringSingle matchgroup=None start=+'+ skip=+\\\\\|\\'+ end=+'+  contains=@phpAddStrings contained keepend
else
  syn region  phpStringDouble matchgroup=None start=+"+ skip=+\\\\\|\\"+ end=+"+  contains=@phpAddStrings,phpIdentifier,phpSpecialChar,phpIdentifierSimply,phpIdentifierComplex contained extend keepend
  syn region  phpBacktick matchgroup=None start=+`+ skip=+\\\\\|\\"+ end=+`+  contains=@phpAddStrings,phpIdentifier,phpSpecialChar,phpIdentifierSimply,phpIdentifierComplex contained extend keepend
  syn region  phpStringSingle matchgroup=None start=+'+ skip=+\\\\\|\\'+ end=+'+  contains=@phpAddStrings contained keepend extend
endif

" HereDoc
if version >= 600
  syn case match
  syn region  phpHereDoc  matchgroup=Delimiter start="\(<<<\)\@<=\z(\I\i*\)$" end="^\z1\(;\=$\)\@=" contained contains=phpIdentifier,phpIdentifierSimply,phpIdentifierComplex,phpSpecialChar,phpMethodsVar keepend extend
" including HTML,JavaScript,SQL even if not enabled via options
  syn region  phpHereDoc  matchgroup=Delimiter start="\(<<<\)\@<=\z(\(\I\i*\)\=\(html\)\c\(\i*\)\)$" end="^\z1\(;\=$\)\@="  contained contains=@htmlTop,phpIdentifier,phpIdentifierSimply,phpIdentifierComplex,phpSpecialChar,phpMethodsVar keepend extend
  syn region  phpHereDoc  matchgroup=Delimiter start="\(<<<\)\@<=\z(\(\I\i*\)\=\(sql\)\c\(\i*\)\)$" end="^\z1\(;\=$\)\@=" contained contains=@sqlTop,phpIdentifier,phpIdentifierSimply,phpIdentifierComplex,phpSpecialChar,phpMethodsVar keepend extend
  syn region  phpHereDoc  matchgroup=Delimiter start="\(<<<\)\@<=\z(\(\I\i*\)\=\(javascript\)\c\(\i*\)\)$" end="^\z1\(;\=$\)\@="  contained contains=@htmlJavascript,phpIdentifierSimply,phpIdentifier,phpIdentifierComplex,phpSpecialChar,phpMethodsVar keepend extend
  syn case ignore
endif

" Parent
if exists("php_parent_error_close") || exists("php_parent_error_open")
  syn match phpParent "[{}]"  contained
  syn region  phpParent matchgroup=Delimiter start="(" end=")"  contained contains=@phpClInside transparent
  syn region  phpParent matchgroup=Delimiter start="\[" end="\]"  contained contains=@phpClInside transparent
  if !exists("php_parent_error_close")
    syn match phpParent "[\])]" contained
  endif
else
  syn match phpParent "[({[\]})]" contained
endif

syn cluster phpClConst  contains=phpFunctions,phpIdentifier,phpConditional,phpRepeat,phpStatement,phpOperator,phpRelation,phpStringSingle,phpStringDouble,phpBacktick,phpNumber,phpFloat,phpKeyword,phpType,phpBoolean,phpStructure,phpMethodsVar,phpConstant,phpCoreConstant,phpException
syn cluster phpClInside contains=@phpClConst,phpComment,phpLabel,phpParent,phpParentError,phpInclude,phpHereDoc
syn cluster phpClFunction contains=@phpClInside,phpDefine,phpParentError,phpStorageClass
syn cluster phpClTop  contains=@phpClFunction,phpFoldFunction,phpFoldClass,phpFoldInterface,phpFoldTry,phpFoldCatch

" Php Region
if exists("php_parent_error_open")
  if exists("php_noShortTags")
    syn region   phpRegion  matchgroup=Delimiter start="<?php" end="?>" contains=@phpClTop
  else
    syn region   phpRegion  matchgroup=Delimiter start="<?\(php\)\=" end="?>" contains=@phpClTop
  endif
  syn region   phpRegionSc  matchgroup=Delimiter start=+<script language="php">+ end=+</script>+  contains=@phpClTop
  if exists("php_asp_tags")
    syn region   phpRegionAsp matchgroup=Delimiter start="<%\(=\)\=" end="%>" contains=@phpClTop
  endif
else
  if exists("php_noShortTags")
    syn region   phpRegion  matchgroup=Delimiter start="<?php" end="?>" contains=@phpClTop keepend
  else
    syn region   phpRegion  matchgroup=Delimiter start="<?\(php\)\=" end="?>" contains=@phpClTop keepend
  endif
  syn region   phpRegionSc  matchgroup=Delimiter start=+<script language="php">+ end=+</script>+  contains=@phpClTop keepend
  if exists("php_asp_tags")
    syn region   phpRegionAsp matchgroup=Delimiter start="<%\(=\)\=" end="%>" contains=@phpClTop keepend
  endif
endif

" Fold
if exists("php_folding") && php_folding==1
" match one line constructs here and skip them at folding
  syn keyword phpSCKeyword  abstract final private protected public static contained
  syn keyword phpFCKeyword  function  contained
  syn keyword phpStorageClass global  contained
  syn match phpDefine "\(\s\|^\)\(abstract\s\+\|final\s\+\|private\s\+\|protected\s\+\|public\s\+\|static\s\+\)*function\(\s\+.*[;}]\)\@="  contained contains=phpSCKeyword
  syn match phpStructure  "\(\s\|^\)\(abstract\s\+\|final\s\+\)*class\(\s\+.*}\)\@="  contained
  syn match phpStructure  "\(\s\|^\)interface\(\s\+.*}\)\@="  contained
  syn match phpException  "\(\s\|^\)try\(\s\+.*}\)\@="  contained
  syn match phpException  "\(\s\|^\)catch\(\s\+.*}\)\@="  contained

  set foldmethod=syntax
  syn region  phpFoldHtmlInside matchgroup=Delimiter start="?>" end="<?\(php\)\=" contained transparent contains=@htmlTop
  syn region  phpFoldFunction matchgroup=Storageclass start="^\z(\s*\)\(abstract\s\+\|final\s\+\|private\s\+\|protected\s\+\|public\s\+\|static\s\+\)*function\s\([^};]*$\)\@="rs=e-9 matchgroup=Delimiter end="^\z1}" contains=@phpClFunction,phpFoldHtmlInside,phpFCKeyword contained transparent fold extend
  syn region  phpFoldFunction matchgroup=Define start="^function\s\([^};]*$\)\@=" matchgroup=Delimiter end="^}" contains=@phpClFunction,phpFoldHtmlInside contained transparent fold extend
  syn region  phpFoldClass  matchgroup=Structure start="^\z(\s*\)\(abstract\s\+\|final\s\+\)*class\s\+\([^}]*$\)\@=" matchgroup=Delimiter end="^\z1}" contains=@phpClFunction,phpFoldFunction,phpSCKeyword contained transparent fold extend
  syn region  phpFoldInterface  matchgroup=Structure start="^\z(\s*\)interface\s\+\([^}]*$\)\@=" matchgroup=Delimiter end="^\z1}" contains=@phpClFunction,phpFoldFunction contained transparent fold extend
  syn region  phpFoldCatch  matchgroup=Exception start="^\z(\s*\)catch\s\+\([^}]*$\)\@=" matchgroup=Delimiter end="^\z1}" contains=@phpClFunction,phpFoldFunction contained transparent fold extend
  syn region  phpFoldTry  matchgroup=Exception start="^\z(\s*\)try\s\+\([^}]*$\)\@=" matchgroup=Delimiter end="^\z1}" contains=@phpClFunction,phpFoldFunction contained transparent fold extend
elseif exists("php_folding") && php_folding==2
  syn keyword phpDefine function  contained
  syn keyword phpStructure  abstract class interface  contained
  syn keyword phpException  catch throw try contained
  syn keyword phpStorageClass final global private protected public static  contained

  set foldmethod=syntax
  syn region  phpFoldHtmlInside matchgroup=Delimiter start="?>" end="<?\(php\)\=" contained transparent contains=@htmlTop
  syn region  phpParent matchgroup=Delimiter start="{" end="}"  contained contains=@phpClFunction,phpFoldHtmlInside transparent fold
else
  syn keyword phpDefine function  contained
  syn keyword phpStructure  abstract class interface  contained
  syn keyword phpException  catch throw try contained
  syn keyword phpStorageClass final global private protected public static  contained
endif

" ================================================================
" Peter Hodge - June 9, 2006
" Some of these changes (highlighting isset/unset/echo etc) are not so
" critical, but they make things more colourful. :-)

" corrected highlighting for an escaped '\$' inside a double-quoted string
syn match phpSpecialChar  "\\\$"  contained display

" highlight object variables inside strings
syn match phpMethodsVar "->\h\w*" contained contains=phpMethods,phpMemberSelector display containedin=phpStringDouble

" highlight constant E_STRICT
syntax case match
syntax keyword phpCoreConstant E_STRICT contained
syntax case ignore

" different syntax highlighting for 'echo', 'print', 'switch', 'die' and 'list' keywords
" to better indicate what they are.
syntax keyword phpDefine echo print contained
syntax keyword phpStructure list contained
syntax keyword phpConditional switch contained
syntax keyword phpStatement die contained

" Highlighting for PHP5's user-definable magic class methods
syntax keyword phpSpecialFunction containedin=ALLBUT,phpComment,phpStringDouble,phpStringSingle,phpIdentifier
  \ __construct __destruct __call __toString __sleep __wakeup __set __get __unset __isset __clone __set_state
" Highlighting for __autoload slightly different from line above
syntax keyword phpSpecialFunction containedin=ALLBUT,phpComment,phpStringDouble,phpStringSingle,phpIdentifier,phpMethodsVar
  \ __autoload
highlight link phpSpecialFunction phpOperator

" Highlighting for PHP5's built-in classes
" - built-in classes harvested from get_declared_classes() in 5.1.4
syntax keyword phpClasses containedin=ALLBUT,phpComment,phpStringDouble,phpStringSingle,phpIdentifier,phpMethodsVar
  \ stdClass __PHP_Incomplete_Class php_user_filter Directory ArrayObject
  \ Exception ErrorException LogicException BadFunctionCallException BadMethodCallException DomainException
  \ RecursiveIteratorIterator IteratorIterator FilterIterator RecursiveFilterIterator ParentIterator LimitIterator
  \ CachingIterator RecursiveCachingIterator NoRewindIterator AppendIterator InfiniteIterator EmptyIterator
  \ ArrayIterator RecursiveArrayIterator DirectoryIterator RecursiveDirectoryIterator
  \ InvalidArgumentException LengthException OutOfRangeException RuntimeException OutOfBoundsException
  \ OverflowException RangeException UnderflowException UnexpectedValueException
  \ PDO PDOException PDOStatement PDORow
  \ DateTime DateTimeZone DateInterval DatePeriod
  \ Reflection ReflectionFunction ReflectionParameter ReflectionMethod ReflectionClass
  \ ReflectionObject ReflectionProperty ReflectionExtension ReflectionException
  \ SplFileInfo SplFileObject SplTempFileObject SplObjectStorage
  \ XMLWriter LibXMLError XMLReader SimpleXMLElement SimpleXMLIterator
  \ DOMException DOMStringList DOMNameList DOMDomError DOMErrorHandler
  \ DOMImplementation DOMImplementationList DOMImplementationSource
  \ DOMNode DOMNameSpaceNode DOMDocumentFragment DOMDocument DOMNodeList DOMNamedNodeMap
  \ DOMCharacterData DOMAttr DOMElement DOMText DOMComment DOMTypeinfo DOMUserDataHandler
  \ DOMLocator DOMConfiguration DOMCdataSection DOMDocumentType DOMNotation DOMEntity
  \ DOMEntityReference DOMProcessingInstruction DOMStringExtend DOMXPath
highlight link phpClasses phpFunctions

" Highlighting for PHP5's built-in interfaces
" - built-in classes harvested from get_declared_interfaces() in 5.1.4
syntax keyword phpInterfaces containedin=ALLBUT,phpComment,phpStringDouble,phpStringSingle,phpIdentifier,phpMethodsVar
  \ Iterator IteratorAggregate RecursiveIterator OuterIterator SeekableIterator
  \ Traversable ArrayAccess Serializable Countable SplObserver SplSubject Reflector
highlight link phpInterfaces phpConstant

" option defaults:
if ! exists('php_special_functions')
    let php_special_functions = 1
endif
if ! exists('php_alt_comparisons')
    let php_alt_comparisons = 1
endif
if ! exists('php_alt_assignByReference')
    let php_alt_assignByReference = 1
endif

if php_special_functions
    " Highlighting for PHP built-in functions which exhibit special behaviours
    " - isset()/unset()/empty() are not real functions.
    " - compact()/extract() directly manipulate variables in the local scope where
    "   regular functions would not be able to.
    " - eval() is the token 'make_your_code_twice_as_complex()' function for PHP.
    " - user_error()/trigger_error() can be overloaded by set_error_handler and also
    "   have the capacity to terminate your script when type is E_USER_ERROR.
    syntax keyword phpSpecialFunction containedin=ALLBUT,phpComment,phpStringDouble,phpStringSingle
  \ user_error trigger_error isset unset eval extract compact empty
endif

if php_alt_assignByReference
    " special highlighting for '=&' operator
    syntax match phpAssignByRef /=\s*&/ containedin=ALLBUT,phpComment,phpStringDouble,phpStringSingle
    highlight link phpAssignByRef Type
endif

if php_alt_comparisons
  " highlight comparison operators differently
  syntax match phpComparison "\v[=!]\=\=?" contained containedin=phpRegion
  syntax match phpComparison "\v[=<>-]@<![<>]\=?[<>]@!" contained containedin=phpRegion

  " highlight the 'instanceof' operator as a comparison operator rather than a structure
  syntax case ignore
  syntax keyword phpComparison instanceof contained containedin=phpRegion

  hi link phpComparison Statement
endif

" ================================================================

" Sync
if php_sync_method==-1
  if exists("php_noShortTags")
    syn sync match phpRegionSync grouphere phpRegion "^\s*<?php\s*$"
  else
    syn sync match phpRegionSync grouphere phpRegion "^\s*<?\(php\)\=\s*$"
  endif
  syn sync match phpRegionSync grouphere phpRegionSc +^\s*<script language="php">\s*$+
  if exists("php_asp_tags")
    syn sync match phpRegionSync grouphere phpRegionAsp "^\s*<%\(=\)\=\s*$"
  endif
  syn sync match phpRegionSync grouphere NONE "^\s*?>\s*$"
  syn sync match phpRegionSync grouphere NONE "^\s*%>\s*$"
  syn sync match phpRegionSync grouphere phpRegion "function\s.*(.*\$"
  "syn sync match phpRegionSync grouphere NONE "/\i*>\s*$"
elseif php_sync_method>0
  exec "syn sync minlines=" . php_sync_method
else
  exec "syn sync fromstart"
endif

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_php_syn_inits")
  if version < 508
    let did_php_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink   phpConstant  Constant
  HiLink   phpCoreConstant  Constant
  HiLink   phpComment Comment
  HiLink   phpException Exception
  HiLink   phpBoolean Boolean
  HiLink   phpStorageClass  StorageClass
  HiLink   phpSCKeyword StorageClass
  HiLink   phpFCKeyword Define
  HiLink   phpStructure Structure
  HiLink   phpStringSingle  String
  HiLink   phpStringDouble  String
  HiLink   phpBacktick  String
  HiLink   phpNumber  Number
  HiLink   phpFloat Float
  HiLink   phpMethods Function
  HiLink   phpFunctions Function
  HiLink   phpBaselib Function
  HiLink   phpRepeat  Repeat
  HiLink   phpConditional Conditional
  HiLink   phpLabel Label
  HiLink   phpStatement Statement
  HiLink   phpKeyword Statement
  HiLink   phpType  Type
  HiLink   phpInclude Include
  HiLink   phpDefine  Define
  HiLink   phpSpecialChar SpecialChar
  HiLink   phpParent  Delimiter
  HiLink   phpIdentifierConst Delimiter
  HiLink   phpParentError Error
  HiLink   phpOctalError  Error
  HiLink   phpTodo  Todo
  HiLink   phpMemberSelector  Structure
  if exists("php_oldStyle")
  hi  phpIntVar guifg=Red ctermfg=DarkRed
  hi  phpEnvVar guifg=Red ctermfg=DarkRed
  hi  phpOperator guifg=SeaGreen ctermfg=DarkGreen
  hi  phpVarSelector guifg=SeaGreen ctermfg=DarkGreen
  hi  phpRelation guifg=SeaGreen ctermfg=DarkGreen
  hi  phpIdentifier guifg=DarkGray ctermfg=Brown
  hi  phpIdentifierSimply guifg=DarkGray ctermfg=Brown
  else
  HiLink  phpIntVar Identifier
  HiLink  phpEnvVar Identifier
  HiLink  phpOperator Operator
  HiLink  phpVarSelector  Operator
  HiLink  phpRelation Operator
  HiLink  phpIdentifier Identifier
  HiLink  phpIdentifierSimply Identifier
  endif

  delcommand HiLink
endif

let b:current_syntax = "php"

if main_syntax == 'php'
  unlet main_syntax
endif

" vim: ts=8 sts=2 sw=2 expandtab

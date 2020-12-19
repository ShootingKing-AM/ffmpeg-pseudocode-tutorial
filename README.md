# FFmpeg/libav Pseudocode Tutorial
A broad workflow understanding of ffmpeg-cli through loose pseudocode.

FFmpeg-cli source from [github/FFmpeg](https://github.com/FFmpeg/FFmpeg#ffmpeg-readme), Dec'2020 - [Tree](https://github.com/FFmpeg/FFmpeg/tree/001bc594d82f3df67a6e96c6ea022f4e39002385)

## Rationale
[FFmpeg](http://ffmpeg.org/about.html) is a collection of libraries and includes a command-line-interface(*cli*) tool to **manipulate, convert and stream multimedia** content.

The goal of understanding ffmpeg-cli is to be able to to integrate FFmpeg into our projects without having to call the ffmpeg-cli in background to do multimedia operation. This is important because,
1. Starting up an external executable tends to be blocked by antivirus software and can cause issues with users.
2. Optimize your project specific libav usage and skip unnecessary code from ffmpeg-cli

Also, ffmpeg official documentation being vague at best, the only option for developers looking to implement ffmpeg's libraries (`libav`) functionality into their code is to read the command line interface's source code.

Reading ffmpeg-cli's source code is very hard, because its not meant to be used as a study material for understanding how to use `libav` but as a optimized multimedia tool. Hence, i tried to straighten out its source code into simple pseudocode function highlighting **when and where** to call important(almost all) libav's functions, for an overall broader picture of ffmpeg workflow. For information regarding **how** to call a `libav` function call, one can refer to the [doxygen documentation](https://ffmpeg.org/doxygen/4.1/index.html) and [ffmpeg-cli-source files](https://github.com/FFmpeg/FFmpeg/tree/master/fftools).

Lack of tutorials in this regard compelled me to open-source this document.

## How to read through Pseudocode 
1. This pseudocode, assumes you have basic multimedia knowledge and ffmpeg internal structure. (if not head over to this [picture tutorial](https://github.com/leandromoreira/ffmpeg-libav-tutorial/blob/master/README.md)).
2. This pseudocode also assumes you have basic understanding of C(++) functions.
3. The `syntactical rules` of the following pseudocode are,

	**a.** There are `two sets` of functions, <br/><br/>
		i. `Standard library calls`, those are available in *libav* headers(, .libs, .dlls), and<br/>
		ii. `ffmpeg-cli specific functions`(non-std functions), these should be understood and should be implemented in your specific project.<br/>    
		`Non-std` function have been named as `<file>::<functionName>()` in pseudocode, so that you can refer to those specific source files to get the exact working.<br/>
		`Std` function just have `<functionName>()` and usually start with `av*`
    
	**b.** Each <kbd>tab</kbd> indicates that the upcoming function call(s) is/are inside the above function call. For example,
	```swift
	foo()
	    bar()
	```
	This means `bar()` function call is inside `foo()` function and `bar()` is being called by `foo()`.
  
	**c.** `//` indicates there is code which does *something* in place of this comment.<br/>
		`/**/` Indicates a comment which explains the following code.<br/>
		`///` Indicates just a comment.
### ffmpeg-cli Pseudocode
Syntax highlighted pseudocode - [Here](https://github.com/ShootingKing-AM/ffmpeg-psedocode-tutorial/blob/master/pseudoCode.swift)

Functions linked to Doxygen ffmpeg documentation. (Click to Refer).
<pre>
main()
	cmdutils.c::init_dynload()
		SetDllDirectory("")

	register_exit()
		ffmpeg.c::ffmpeg_cleanup()
			// Free filers FilterGraph with <a href="https://ffmpeg.org/doxygen/4.1/group__lavfi.html#ga871684449dac05050df238a18d0d493b">avfilter_graph_free</a>()
				// for each FilterGraph's Input
					<a href="https://ffmpeg.org/doxygen/4.1/libavutil_2fifo_8c.html#ab708d2f19b7a9592caa278256787adb6">av_fifo_generic_read</a>()
					<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__frame.html#ga979d73f3228814aee56aeca0636e37cc">av_frame_free</a>()
					<a href="https://ffmpeg.org/doxygen/4.1/libavutil_2fifo_8c.html#a612be59edb6ab388a82d1487d1bd0c4d">av_fifo_freep</a>()
					<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__core.html#gaa2c3e02a761d9fc0c5c9b2340408c332">avsubtitle_free</a>()
					<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__buffer.html#ga135e9e929b5033bb8f68322497b2effc">av_buffer_unref</a>()
					<a href="https://ffmpeg.org/doxygen/4.1/tableprint__vlc_8h.html#adba82e1bcd02de510a858fcbedf79ef1">av_freep</a>()
					<a href="https://ffmpeg.org/doxygen/4.1/group__lavfi.html#ga294500a9856260eb1552354fd9d9a6c4">avfilter_inout_free</a>()

			// Close Files with <a href="https://ffmpeg.org/doxygen/4.1/avio_8h.html#ae118a1f37f1e48617609ead9910aac15">avio_closep</a>()
				<a href="https://ffmpeg.org/doxygen/4.1/group__lavf__core.html#gac2990b13b68e831a408fce8e1d0d6445">avformat_free_context</a>()
				<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__dict.html#ga1bafd682b1fbb90e48a4cc3814b820f7">av_dict_free</a>()
				<a href="https://ffmpeg.org/doxygen/4.1/tableprint__vlc_8h.html#adba82e1bcd02de510a858fcbedf79ef1">av_freep</a>()

			// Close Output Streams <a href="https://ffmpeg.org/doxygen/4.1/group__lavc__misc.html#ga08d53431e76355f88e27763b1940df4f">av_bsf_free</a>()
				<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__frame.html#ga979d73f3228814aee56aeca0636e37cc">av_frame_free</a>()
				<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__frame.html#ga979d73f3228814aee56aeca0636e37cc">av_frame_free</a>()
				<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__dict.html#ga1bafd682b1fbb90e48a4cc3814b820f7">av_dict_free</a>()

				<a href="https://ffmpeg.org/doxygen/4.1/tableprint__vlc_8h.html#adba82e1bcd02de510a858fcbedf79ef1">av_freep</a>()
				<a href="https://ffmpeg.org/doxygen/4.1/eval_8c.html#a01c05d7049a9208c2b22147a3f16c58c">av_expr_free</a>()
				<a href="https://ffmpeg.org/doxygen/4.1/tableprint__vlc_8h.html#adba82e1bcd02de510a858fcbedf79ef1">av_freep</a>()

				<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__core.html#gaf869d0829ed607cec3a4a02a1c7026b3">avcodec_free_context</a>()
				<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__core.html#ga950c8da55b8112077e640b6a0cb8cf36">avcodec_parameters_free</a>()

				<a href="https://ffmpeg.org/doxygen/4.1/libavutil_2fifo_8c.html#ab708d2f19b7a9592caa278256787adb6">av_fifo_generic_read</a>(muxing_queue, &pkt)
				<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__packet.html#ga63d5a489b419bd5d45cfd09091cbcbc2">av_packet_unref</a>(&pkt)					
				<a href="https://ffmpeg.org/doxygen/4.1/libavutil_2fifo_8c.html#a612be59edb6ab388a82d1487d1bd0c4d">av_fifo_freep</a>(muxing_queue)

			free_input_threads()
				
			// Close input Files <a href="https://ffmpeg.org/doxygen/4.1/group__lavf__decoding.html#gae804b99aec044690162b8b9b110236a4">avformat_close_input</a>()
				<a href="https://ffmpeg.org/doxygen/4.1/tableprint__vlc_8h.html#adba82e1bcd02de510a858fcbedf79ef1">av_freep</a>()

			// Close input Streams
				<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__frame.html#ga979d73f3228814aee56aeca0636e37cc">av_frame_free</a>(decoded_frame)
				<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__frame.html#ga979d73f3228814aee56aeca0636e37cc">av_frame_free</a>(filter_frame)
				<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__dict.html#ga1bafd682b1fbb90e48a4cc3814b820f7">av_dict_free</a>(decoder_opts)
				avsubtitle_freesubtitle)
				<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__frame.html#ga979d73f3228814aee56aeca0636e37cc">av_frame_free</a>(sub2video.frame)
				<a href="https://ffmpeg.org/doxygen/4.1/tableprint__vlc_8h.html#adba82e1bcd02de510a858fcbedf79ef1">av_freep</a>(filters)
				<a href="https://ffmpeg.org/doxygen/4.1/tableprint__vlc_8h.html#adba82e1bcd02de510a858fcbedf79ef1">av_freep</a>(hwaccel_device)
				<a href="https://ffmpeg.org/doxygen/4.1/tableprint__vlc_8h.html#adba82e1bcd02de510a858fcbedf79ef1">av_freep</a>(dts_buffer)
				<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__core.html#gaf869d0829ed607cec3a4a02a1c7026b3">avcodec_free_context</a>(dec_ctx)
				<a href="https://ffmpeg.org/doxygen/4.1/tableprint__vlc_8h.html#adba82e1bcd02de510a858fcbedf79ef1">av_freep</a>(input_streams)

			<a href="https://ffmpeg.org/doxygen/4.1/group__lavf__core.html#ga245f2875f80ce67ec3d1e0f54dacf2c4">avformat_network_deinit</a>()

	<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__log.html#gaf8143cc9a7cd364af1ff525c6181c0ce">av_log_set_flags</a>()

	// if CONFIG_AVDEVICE set <a href="https://ffmpeg.org/doxygen/4.1/group__lavd.html#ga7c90a3585267b55941ae2f7388c006b6">avdevice_register_all</a>();

	<a href="https://ffmpeg.org/doxygen/4.1/group__lavf__core.html#ga84542023693d61e8564c5d457979c932">avformat_network_init</a>()

	ffmpeg_opt.c::ffmpeg_parse_options()
		options = cmdutils.c::split_commandline() /* split the commandline into an internal representation */
			cmdutils.c::prepare_app_arguments() /* perform system-dependent conversions for arguments list */
			cmdutils.c::init_parse_context() 
				cmdutils.c::init_opts() 
					<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__dict.html#ga8d9c2de72b310cef8e6a28c9cd3acbbe">av_dict_set</a>()
		cmdutils.c::parse_optgroup("GLOABAL")

		cmdutils.c::open_files()
			ffmpeg_opt.c::open_input_file()
				// Check if supported file format with 
				libavformat::<a href="https://ffmpeg.org/doxygen/4.1/group__lavf__decoding.html#ga7d2f532c6653c2419b17956712fdf3da">av_find_input_format</a>()
				inputContext = libavformat::<a href="https://ffmpeg.org/doxygen/4.1/group__lavf__core.html#gac7a91abf2f59648d995894711f070f62">avformat_alloc_context</a>()
				<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__dict.html#gafd013a88620b2da7d497b083f6ea7d29">av_dict_set_int</a>() /* Setting global Opts as per Input file opts */
				find_codec_or_die()
					<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__encoding.html#gaa614ffc38511c104bdff4a3afa086d37">avcodec_find_encoder_by_name</a>()
				// Set inputContext's members as per codec
				libavformat::<a href="https://ffmpeg.org/doxygen/4.1/group__lavf__decoding.html#ga31d601155e9035d5b0e7efedc894ee49">avformat_open_input</a>()
				libavformat::<a href="https://ffmpeg.org/doxygen/4.1/group__lavf__decoding.html#gad42172e27cddafb81096939783b157bb">avformat_find_stream_info</a>()
				// if specified in cmd line options, <a href="https://ffmpeg.org/doxygen/4.1/group__lavf__decoding.html#ga3b40fc8d2fda6992ae6ea2567d71ba30">avformat_seek_file</a>()
				ffmpeg_opt.c::add_input_streams()/* Add all the streams from the given input file to the global list of input streams. */
					dec_Context = <a href="https://ffmpeg.org/doxygen/4.1/group__lavc__core.html#gae80afec6f26df6607eaacf39b561c315">avcodec_alloc_context3</a>()
					<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__core.html#gac7b282f51540ca7a99416a3ba6ee0d16">avcodec_parameters_to_context</a>(dec_Context, cmdLineParameters)
						// Based on Codec_Type (VID, AUD, SUB, etc, etc)
							VID:
							<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__decoding.html#ga19a0ca553277f019dd5b0fec6e1f9dca">avcodec_find_decoder</a>()
								// Specific to HwAccelearation 
									<a href="https://ffmpeg.org/doxygen/4.1/pixdesc_8c.html#a925ef18d69c24c3be8c53d5a7dc0660e">av_get_pix_fmt</a>()
									<a href="https://ffmpeg.org/doxygen/4.1/hwcontext_8c.html#a541943ddced791765349645a30adfa4d">av_hwdevice_find_type_by_name</a>()
							AUD:
							ffmpeg.c::guess_input_channel_layout()
								<a href="https://ffmpeg.org/doxygen/4.1/group__channel__mask__c.html#gacb84f3e93a583e1f84a5283162a606a2">av_get_default_channel_layout</a>()
								<a href="https://ffmpeg.org/doxygen/4.1/group__channel__mask__c.html#ga99d0b5bb80534d13a6cc96336cf9076a">av_get_channel_layout_string</a>()
							DATA, SUB:
							<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__decoding.html#ga19a0ca553277f019dd5b0fec6e1f9dca">avcodec_find_decoder</a>()
							ATTACHMENT, UNKNOWN:
							// Do Nothing here
					<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__core.html#ga0c7058f764778615e7978a1821ab3cfe">avcodec_parameters_from_context</a>()
				<a href="https://ffmpeg.org/doxygen/4.1/group__lavf__misc.html#gae2645941f2dc779c307eb6314fd39f10">av_dump_format</a>()
		ffmpeg_opt.c::init_complex_filters()
			ffmpeg_filter.c::init_complex_filtergraph()
				<a href="https://ffmpeg.org/doxygen/4.1/group__lavfi.html#ga6c778454b86f845805ffd814b4ce51d4">avfilter_graph_alloc</a>()
				<a href="https://ffmpeg.org/doxygen/4.1/group__lavfi.html#ga6c3c39e0861653c71a23f90d1397239d">avfilter_graph_parse2</a>()
					on fail,
						<a href="https://ffmpeg.org/doxygen/4.1/group__lavfi.html#ga294500a9856260eb1552354fd9d9a6c4">avfilter_inout_free</a>();
						<a href="https://ffmpeg.org/doxygen/4.1/group__lavfi.html#ga871684449dac05050df238a18d0d493b">avfilter_graph_free</a>();
				For all Inputs,
					ffmpeg_filter.c::init_input_filter()
						<a href="https://ffmpeg.org/doxygen/4.1/group__lavfi.html#ga2d241a0066fc3724ec3335e25bc3912e">avfilter_pad_get_type</a>()
							cmdutils.c::check_stream_specifier()
								<a href="https://ffmpeg.org/doxygen/4.1/group__lavf__misc.html#ga7e45597834e9ef3098ddb74bc5e1550c">avformat_match_stream_specifier</a>()
						<a href="https://ffmpeg.org/doxygen/4.1/libavutil_2fifo_8c.html#adae9b18c5eed14fe851c5bb984ce374b">av_fifo_alloc</a>()
				For all outputs,
					<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__mem__funcs.html#ga0a8cc057ae9723ce3b9203cb5365971a">av_mallocz</a>()
					<a href="https://ffmpeg.org/doxygen/4.1/group__lavfi.html#ga2d241a0066fc3724ec3335e25bc3912e">avfilter_pad_get_type</a>()
					ffmpeg_filter.c::describe_filter_link()
						<a href="https://ffmpeg.org/doxygen/4.1/avio_8h.html#adb5259ad07633518173eaa47fe6575e2">avio_open_dyn_buf</a>()
						<a href="https://ffmpeg.org/doxygen/4.1/avio_8h.html#a79127cec97b09a308b549253119ff38f">avio_printf</a>()
						<a href="https://ffmpeg.org/doxygen/4.1/avio_8h.html#a1dddee2b73f4dd6512ac9821cf5adc18">avio_w8</a>()
						<a href="https://ffmpeg.org/doxygen/4.1/avio_8h.html#a8faed62ce72e7411cbea2356494af8ce">avio_close_dyn_buf</a>()
		cmdutils.c::open_files()
			ffmpeg_opt.c::open_output_file()
				// if no Stream maps
					<a href="https://ffmpeg.org/doxygen/4.1/avformat_8h.html#a6ddf3d982feb45fa5081420ee911f5d5">avformat_alloc_output_context2</a>()	
					<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__dict.html#gae67f143237b2cb2936c9b147aa6dfde3">av_dict_get</a>()
					<a href="https://ffmpeg.org/doxygen/4.1/group__avoptions.html#gae31ae7fb20113b00108d0ecf53f25664">av_opt_find</a>()
					<a href="https://ffmpeg.org/doxygen/4.1/group__opt__eval__funcs.html#gae245940b870e13b759354d570decf3dc">av_opt_eval_flags</a>()
				
					/* create streams for all unlabeled output pads */
					ffmpeg_opt.c::init_output_filter()
						// Based on Type
						VID:
							ffmpeg_opt.c::new_video_stream()
								ffmpeg_opt.c::new_output_stream()
									<a href="https://ffmpeg.org/doxygen/4.1/group__lavf__core.html#gadcb0fd3e507d9b58fe78f61f8ad39827">avformat_new_stream</a>()
									<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__mem__funcs.html#ga0a8cc057ae9723ce3b9203cb5365971a">av_mallocz</a>()
									ffmpeg_opt.c::choose_encoder()
										<a href="https://ffmpeg.org/doxygen/4.1/group__lavf__encoding.html#gae8a1efab53a348857f209ea51037da4c">av_guess_codec</a>()
										<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__encoding.html#ga9f820c481615c3a02d0407bac0bdbf25">avcodec_find_encoder</a>()
									<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__core.html#gae80afec6f26df6607eaacf39b561c315">avcodec_alloc_context3</a>()
									<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__core.html#ga647755ab2252e93221bb345f3d5e414f">avcodec_parameters_alloc</a>()
									ffmpeg_opt.c::get_preset_file_2()
										<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__dict.html#ga8d9c2de72b310cef8e6a28c9cd3acbbe">av_dict_set</a>()
										<a href="https://ffmpeg.org/doxygen/4.1/tableprint__vlc_8h.html#a079eab092887563f2bef9106c6120089">av_free</a>()
										<a href="https://ffmpeg.org/doxygen/4.1/avio_8h.html#ae118a1f37f1e48617609ead9910aac15">avio_closep</a>();
									<a href="https://ffmpeg.org/doxygen/4.1/parseutils_8c.html#a8535b8693aa5a188cfb1356133c0e94e">av_parse_ratio</a>() // for Timebase and enc_Timebase
									// Parse and Set options
								<a href="https://ffmpeg.org/doxygen/4.1/parseutils_8c.html#a63c6a2937ebf4b6722c255286755e557">av_parse_video_rate</a>()
								<a href="https://ffmpeg.org/doxygen/4.1/parseutils_8c.html#a8535b8693aa5a188cfb1356133c0e94e">av_parse_ratio</a>() // for AspectRatio
								<a href="https://ffmpeg.org/doxygen/4.1/parseutils_8c.html#a4dcdb8a2792f2074ca4a1e1f4ddce2bf">av_parse_video_size</a>()
								<a href="https://ffmpeg.org/doxygen/4.1/pixdesc_8c.html#a925ef18d69c24c3be8c53d5a7dc0660e">av_get_pix_fmt</a>()
								<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__misc.html#ga553b85a36da32c041738a89aa61f9fbd">av_fopen_utf8</a>() // log file
								ffmpeg_opt.c::get_ost_filters()
									read_file() //read filter script from file
										<a href="https://ffmpeg.org/doxygen/4.1/avio_8h.html#a371a670112abc5f3e15bc570da076301">avio_open</a>()
										<a href="https://ffmpeg.org/doxygen/4.1/avio_8h.html#adb5259ad07633518173eaa47fe6575e2">avio_open_dyn_buf</a>()
										<a href="https://ffmpeg.org/doxygen/4.1/avio_8h.html#abb4e58439be0bff0dc2e2974ee5fb6a3">avio_read</a>()
										<a href="https://ffmpeg.org/doxygen/4.1/avio_8h.html#acc3626afc6aa3964b75d02811457164e">avio_write</a>()
										<a href="https://ffmpeg.org/doxygen/4.1/avio_8h.html#a1dddee2b73f4dd6512ac9821cf5adc18">avio_w8</a>()
										<a href="https://ffmpeg.org/doxygen/4.1/avio_8h.html#ae118a1f37f1e48617609ead9910aac15">avio_closep</a>()
										<a href="https://ffmpeg.org/doxygen/4.1/avio_8h.html#a8faed62ce72e7411cbea2356494af8ce">avio_close_dyn_buf</a>()
									or get from CmdLine <a href="https://ffmpeg.org/doxygen/4.1/group__lavu__mem__funcs.html#ga7c352f4cff02184f005323691375fea9">av_strdup</a>()
						AUD:
							ffmpeg_opt.c::new_audio_stream()
								ffmpeg_opt.c::new_output_stream() // Same calls as above incase of VID
							<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__sampfmts.html#ga655c989b749667468e5e839e26fe63db">av_get_sample_fmt</a>()
							get_ost_filters()
							<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__mem__funcs.html#gad8fde0c159ac905909339e082a049cde">av_reallocp_array</a>()
						<a href="https://ffmpeg.org/doxygen/4.1/group__lavfi.html#ga294500a9856260eb1552354fd9d9a6c4">avfilter_inout_free</a>()
					// Based on Type (VID, AUD)
					VID:
						<a href="https://ffmpeg.org/doxygen/4.1/group__lavf__encoding.html#gae8a1efab53a348857f209ea51037da4c">av_guess_codec</a>()
						<a href="https://ffmpeg.org/doxygen/4.1/group__lavf__misc.html#gaa90b4c72d1bbb298e11096d3a09ec7db">avformat_query_codec</a>()
						ffmpeg_opt.c::new_video_stream() // Same calls as above
					AUD:
						<a href="https://ffmpeg.org/doxygen/4.1/group__lavf__encoding.html#gae8a1efab53a348857f209ea51037da4c">av_guess_codec</a>()
						ffmpeg_opt.c::new_audio_stream() // Same calls as above
					SUBTITLE:
						<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__encoding.html#ga9f820c481615c3a02d0407bac0bdbf25">avcodec_find_encoder</a>()
						<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__misc.html#gac09f8ddc2d4b36c5a85c6befba0d0888">avcodec_descriptor_get</a>()
						ffmpeg_opt.c::new_subtitle_stream()
							ffmpeg_opt.c::new_output_stream() // Same Calls as above
					DATA:
						<a href="https://ffmpeg.org/doxygen/4.1/group__lavf__encoding.html#gae8a1efab53a348857f209ea51037da4c">av_guess_codec</a>()
				else
					// For all stream maps
						if LinkLabel
							init_output_filter() // Same class as above
						else
							case AVMEDIA_TYPE_VIDEO:      new_video_stream()
							case AVMEDIA_TYPE_AUDIO:      new_audio_stream()
							case AVMEDIA_TYPE_SUBTITLE:   new_subtitle_stream()
							case AVMEDIA_TYPE_DATA:       new_data_stream()
							case AVMEDIA_TYPE_ATTACHMENT: new_attachment_stream()
							case AVMEDIA_TYPE_UNKNOWN:    new_unknown_stream()
			/* handle attached files */
				<a href="https://ffmpeg.org/doxygen/4.1/avio_8h.html#ade8a63980569494c99593ebf0d1e891b">avio_open2</a>()
				<a href="https://ffmpeg.org/doxygen/4.1/tableprint__vlc_8h.html#ae97db1f58b6b1515ed57a83bea3dd572">av_malloc</a>()
				<a href="https://ffmpeg.org/doxygen/4.1/avio_8h.html#abb4e58439be0bff0dc2e2974ee5fb6a3">avio_read</a>()
				ffmpeg_opt.c::new_attachment_stream()
				<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__dict.html#ga8d9c2de72b310cef8e6a28c9cd3acbbe">av_dict_set</a>()
				<a href="https://ffmpeg.org/doxygen/4.1/avio_8h.html#ae118a1f37f1e48617609ead9910aac15">avio_closep</a>()
			// Set options

			/* set the decoding_needed flags and create simple filtergraphs */
			ffmpeg_opt.c::init_simple_filtergraph()
			// set the filter output constraints

			<a href="https://ffmpeg.org/doxygen/4.1/avio_8h.html#ade8a63980569494c99593ebf0d1e891b">avio_open2</a>()

			// copy metadata
			// copy chapters
			// copy global metadata by default

			// process manually set programs
			<a href="https://ffmpeg.org/doxygen/4.1/group__lavf__core.html#gab31f7c7c99dcadead38e8e83e0fdb828">av_new_program</a>()
		on fail, uninit_parse_context()

	/* The following code is the main loop of the file converter */
	ffmpeg.c::transcode()
		ffmpeg.c::transcode_init()
			//Link FilterGraphs and OutputFilter

			/* init framerate emulation */
			InputFile.InputStreams = <a href="https://ffmpeg.org/doxygen/4.1/time_8c.html#adf0e36df54426fa167e3cc5a3406f3b7">av_gettime_relative</a>()

			/* init input streams */
			ffmpeg.c::init_input_stream()
				/* Set Dec_Context Options */
				<a href="https://ffmpeg.org/doxygen/4.1/group__opt__set__funcs.html#ga3adf7185c21cc080890a5ec02c2e56b2">av_opt_set_int</a>()
				<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__dict.html#ga8d9c2de72b310cef8e6a28c9cd3acbbe">av_dict_set</a>()
				ffmpeg_hw.c::hw_device_setup_for_decode()
					ffmpeg_hw.c::hw_device_get_by_name()
					ffmpeg_hw.c::hw_device_init_from_type()
						ffmpeg_hw.c::hw_device_default_name()
							<a href="https://ffmpeg.org/doxygen/4.1/hwcontext_8c.html#afb2b99a15f3fdde25a2fd19353ac5a67">av_hwdevice_get_type_name</a>()							
						<a href="https://ffmpeg.org/doxygen/4.1/hwcontext_8c.html#a21fbd088225e4e25c4d9a01b3f5e8c51">av_hwdevice_ctx_create</a>()
						ffmpeg_hw.c::hw_device_add()
							<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__mem__funcs.html#gad8fde0c159ac905909339e082a049cde">av_reallocp_array</a>(hw_devices)
							<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__mem__funcs.html#ga0a8cc057ae9723ce3b9203cb5365971a">av_mallocz</a>()
						On fail, <a href="https://ffmpeg.org/doxygen/4.1/tableprint__vlc_8h.html#adba82e1bcd02de510a858fcbedf79ef1">av_freep</a>() & av_buffer_unref()
					if Generic HWACCEL_AUTO Device, 
						hw_device_match_by_codec()
						<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__core.html#ga4f80582a2ea9c0e141de5d6f6152008f">avcodec_get_hw_config</a>()
						hw_device_init_from_type()
				<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__core.html#ga11f785a188d7d9df71621001465b0f1d">avcodec_open2</a>()
			On fail init_input_stream(), Close all Encoding contexts with <a href="https://ffmpeg.org/doxygen/4.1/group__lavc__core.html#gaf4daa92361efb3523ef5afeb0b54077f">avcodec_close</a>()
			/*
			 * initialize stream copy and subtitle/data streams.
			 * Encoded AVFrame based streams will get initialized as follows:
			 * - when the first AVFrame is received in do_video_out
			 * - just before the first AVFrame is received in either transcode_step
			 *   or reap_filters due to us requiring the filter chain buffer sink
			 *   to be configured with the correct audio frame size, which is only
			 *   known after the encoder is initialized.
			 */
			 ffmpeg.c::init_output_stream_wrapper()
				ffmpeg.c::init_output_stream()
					/* If encoding_needed */
						ffmpeg.c::init_output_stream_encode()
							// Set Options
							Based on Codec Type,
							AUD:
								<a href="https://ffmpeg.org/doxygen/4.1/group__lavfi__buffersink__accessors.html#ga402ddbef6f7347869725696846ac81eb">av_buffersink_get_format</a>()
								<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__sampfmts.html#ga0c3c218e1dd570ad4917c69a35a6c77d">av_get_bytes_per_sample</a>()
								<a href="https://ffmpeg.org/doxygen/4.1/group__lavfi__buffersink__accessors.html#ga2af714e82f48759551acdbc4488ded4a">av_buffersink_get_sample_rate</a>()
								<a href="https://ffmpeg.org/doxygen/4.1/group__lavfi__buffersink__accessors.html#ga87e21bf198fd932c30cc3cdc6b16bff1">av_buffersink_get_channel_layout</a>()
								<a href="https://ffmpeg.org/doxygen/4.1/group__lavfi__buffersink__accessors.html#gace78881c41bf449527826b95d21279a2">av_buffersink_get_channels</a>()

								ffmpeg.c::init_encoder_time_base() // Based on SampleRate
							VID:
								ffmpeg.c::init_encoder_time_base() // Based on frameRate
								<a href="https://ffmpeg.org/doxygen/4.1/group__lavfi__buffersink__accessors.html#gabc82f65ec7f4fa47c5216260639258a1">av_buffersink_get_time_base</a>()
								<a href="https://ffmpeg.org/doxygen/4.1/group__lavfi__buffersink__accessors.html#gac8c86515d2ef56090395dfd74854c835">av_buffersink_get_w</a>()
								<a href="https://ffmpeg.org/doxygen/4.1/group__lavfi__buffersink__accessors.html#ga955ecf3680e71e10429d7500343be25c">av_buffersink_get_h</a>()
								<a href="https://ffmpeg.org/doxygen/4.1/group__lavfi__buffersink__accessors.html#gaa38ee33e1c7f6f7cb190bd2330e5f848">av_buffersink_get_sample_aspect_ratio</a>()

								<a href="https://ffmpeg.org/doxygen/4.1/group__lavfi__buffersink__accessors.html#ga402ddbef6f7347869725696846ac81eb">av_buffersink_get_format</a>()
								<a href="https://ffmpeg.org/doxygen/4.1/pixdesc_8c.html#afe0c3e8aef5173de28bbdaea4298f5f0">av_pix_fmt_desc_get</a>()

								// Set other options on Enc_Context
							SUB: // Set options
							DATA: // Set Options
						ffmpeg_hw.c::hw_device_setup_for_encode()
							<a href="https://ffmpeg.org/doxygen/4.1/group__lavfi__buffersink__accessors.html#gaa1415790bfe3dacb5af1c60e9eda3714">av_buffersink_get_hw_frames_ctx</a>()
							<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__core.html#ga4f80582a2ea9c0e141de5d6f6152008f">avcodec_get_hw_config</a>()
							// Set Enc_Context Options
						<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__misc.html#gac09f8ddc2d4b36c5a85c6befba0d0888">avcodec_descriptor_get</a>(deCodecContext)
						<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__misc.html#gac09f8ddc2d4b36c5a85c6befba0d0888">avcodec_descriptor_get</a>(OutputStream)

						<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__core.html#ga11f785a188d7d9df71621001465b0f1d">avcodec_open2</a>()
						<a href="https://ffmpeg.org/doxygen/4.1/group__lavfi__buffersink.html#ga359d7d1e42c27ca14c07559d4e9adba7">av_buffersink_set_frame_size</a>()
						<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__core.html#ga0c7058f764778615e7978a1821ab3cfe">avcodec_parameters_from_context</a>(ost->st->codecpar, ost->enc_ctx)
						<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__core.html#gae381631ba4fb14f4124575d9ceacb87e">avcodec_copy_context</a>(ost->st->codec, ost->enc_ctx)
						/* if has coded_side_data, */
							<a href="https://ffmpeg.org/doxygen/4.1/group__lavf__core.html#gae324697cedd36e7b47a1e142dc24b805">av_stream_new_side_data</a>()
							<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__video__display.html#ga5964303bfe085ad33683bc2454768d4a">av_display_rotation_set</a>()
					/* else if StreamCopy */
						ffmpeg.c::init_output_stream_streamcopy()
							<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__core.html#gac7b282f51540ca7a99416a3ba6ee0d16">avcodec_parameters_to_context</a>()
							<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__core.html#ga0c7058f764778615e7978a1821ab3cfe">avcodec_parameters_from_context</a>()
							<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__core.html#ga6d02e640ccc12c783841ce51d09b9fa7">avcodec_parameters_copy</a>()

							<a href="https://ffmpeg.org/doxygen/4.1/group__lavf__misc.html#gae35832b110d26ffa3e8805b3d55e8f36">avformat_transfer_internal_stream_timing_info</a>()

							// copy timebase while removing common factors
							// copy estimated duration as a hint to the muxer
							// copy disposition

							<a href="https://ffmpeg.org/doxygen/4.1/group__lavf__core.html#gae324697cedd36e7b47a1e142dc24b805">av_stream_new_side_data</a>()
							// Set options on OutputStream

					// parse user provided disposition, and update stream values
					
					/* initialize bitstream filters for the output stream
					 * needs to be done here, because the codec id for streamcopy is not
					 * known until now */
					ffmpeg.c::init_output_bsfs()
						<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__core.html#ga6d02e640ccc12c783841ce51d09b9fa7">avcodec_parameters_copy</a>()
						<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__misc.html#ga242529d54013acf87e94273d298a5ff2">av_bsf_init</a>()

					/* open the muxer when all the streams are initialized */
					ffmpeg.c::check_init_output_file()
						OuputFile->interrupt_callback = int_cb;
						<a href="https://ffmpeg.org/doxygen/4.1/group__lavf__encoding.html#ga18b7b10bb5b94c4842de18166bc677cb">avformat_write_header</a>()

						/* flush the muxing queues */
						/* try to improve muxing time_base (only possible if nothing has been written yet) */
						<a href="https://ffmpeg.org/doxygen/4.1/libavutil_2fifo_8c.html#a81f4cea70d96846df7111daccc5ecce2">av_fifo_size</a>()
						<a href="https://ffmpeg.org/doxygen/4.1/libavutil_2fifo_8c.html#ab708d2f19b7a9592caa278256787adb6">av_fifo_generic_read</a>()
						ffmpeg.c::write_packet()
							/*
							 * Audio encoders may split the packets --  #frames in != #packets out.
							 * But there is no reordering, so we can limit the number of output packets
							 * by simply dropping them here.
							 * Counting encoded video frames needs to be done separately because of
							 * reordering, see do_video_out().
							 * Do not count the packet when unqueued because it has been counted when queued.
							 */
							 if headers not written
								/* the muxer is not initialized yet, buffer the packet */
								<a href="https://ffmpeg.org/doxygen/4.1/libavutil_2fifo_8c.html#ac1e0d8ee7f1568cb40fa95a740c60f13">av_fifo_space</a>()
								<a href="https://ffmpeg.org/doxygen/4.1/libavutil_2fifo_8c.html#aeaf7aa802f3b18fef86bb72445eff5d8">av_fifo_realloc2</a>()
								<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__packet.html#ga8a6deff6c1809029037ffd760db3e0d4">av_packet_make_refcounted</a>()
								<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__packet.html#ga91dbb1359f99547adb544ee96a406b21">av_packet_move_ref</a>()
								<a href="https://ffmpeg.org/doxygen/4.1/libavutil_2fifo_8c.html#ae95c15dcdd266b4005f8919e4f571180">av_fifo_generic_write</a>()

							VID:
								<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__packet.html#ga77a800026abd6dc2f4ac1e0ad7e3e999">av_packet_get_side_data</a>()
							
							<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__packet.html#gae5c86e4d93f6e7aa62ef2c60763ea67e">av_packet_rescale_ts</a>()

							// set pts, dts

							<a href="https://ffmpeg.org/doxygen/4.1/group__lavf__encoding.html#ga37352ed2c63493c38219d935e71db6c1">av_interleaved_write_frame</a>()
							<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__packet.html#ga63d5a489b419bd5d45cfd09091cbcbc2">av_packet_unref</a>()
			// discard unused programs

			/* write headers for files with no streams */
			check_init_output_file() // Same calls as above

			// dump the stream mapping

		/// end transcode_init()

		/* Return 1 if there remain streams where more output is wanted, 0 otherwise. */
		ffmpeg.c::need_output()
			close_output_stream()
				<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__math.html#gaf02994a8bbeaa91d4757df179cbe567f">av_rescale_q</a>()

		/**
		 * Run a single step of transcoding.
		 *
		 * @return  0 for success, <0 for error
		 */
		ffmpeg.c::transcode_step()
			/**
			 * Select the output stream to process.
			 *
			 * @return  selected output stream, or NULL if none available
			 */
			ffmpeg.c::choose_output()
				<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__math.html#gaf02994a8bbeaa91d4757df179cbe567f">av_rescale_q</a>()

			if ffmpeg.c::got_eagain()
			ffmpeg.c::reset_eagain()
			// return 0 // Stop FFMPEG

			ffmpeg.c::ifilter_has_all_input_formats()
			ffmpeg_filter.c::configure_filtergraph()
				ffmpeg_filter.c::cleanup_filtergraph()
					// Null Output and Input filters
					<a href="https://ffmpeg.org/doxygen/4.1/group__lavfi.html#ga871684449dac05050df238a18d0d493b">avfilter_graph_free</a>()

				<a href="https://ffmpeg.org/doxygen/4.1/group__lavfi.html#ga6c778454b86f845805ffd814b4ce51d4">avfilter_graph_alloc</a>()

				<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__dict.html#gae67f143237b2cb2936c9b147aa6dfde3">av_dict_get</a>()
				<a href="https://ffmpeg.org/doxygen/4.1/avstring_8c.html#a98e5858f933c6e6be64f03a76e22b272">av_strlcatf</a>()

				<a href="https://ffmpeg.org/doxygen/4.1/group__lavfi.html#ga6c3c39e0861653c71a23f90d1397239d">avfilter_graph_parse2</a>()

				ffmpeg_hw.c::hw_device_setup_for_filter()
					<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__buffer.html#gaa40ce7d3ede946a89d03323bbd7268c1">av_buffer_ref</a>()

				<a href="https://ffmpeg.org/doxygen/4.1/group__lavfi.html#ga294500a9856260eb1552354fd9d9a6c4">avfilter_inout_free</a>()
				<a href="https://ffmpeg.org/doxygen/4.1/group__lavfi.html#gae7e75e3df70de53fae2cf7950c1247a8">avfilter_graph_set_auto_convert</a>()
				<a href="https://ffmpeg.org/doxygen/4.1/group__lavfi.html#ga1896c46b7bc6ff1bdb1a4815faa9ad07">avfilter_graph_config</a>()

                /* limit the lists of allowed formats to the ones selected, to
                 * make sure they stay the same if the filtergraph is reconfigured later */
					<a href="https://ffmpeg.org/doxygen/4.1/group__lavfi__buffersink__accessors.html#ga402ddbef6f7347869725696846ac81eb">av_buffersink_get_format</a>()
					<a href="https://ffmpeg.org/doxygen/4.1/group__lavfi__buffersink__accessors.html#gac8c86515d2ef56090395dfd74854c835">av_buffersink_get_w</a>()
					<a href="https://ffmpeg.org/doxygen/4.1/group__lavfi__buffersink__accessors.html#ga955ecf3680e71e10429d7500343be25c">av_buffersink_get_h</a>()
					<a href="https://ffmpeg.org/doxygen/4.1/group__lavfi__buffersink__accessors.html#ga2af714e82f48759551acdbc4488ded4a">av_buffersink_get_sample_rate</a>()
					<a href="https://ffmpeg.org/doxygen/4.1/group__lavfi__buffersink__accessors.html#ga87e21bf198fd932c30cc3cdc6b16bff1">av_buffersink_get_channel_layout</a>()

				AUD: and AV_CODEC_CAP_VARIABLE_FRAME_SIZE = 0
					<a href="https://ffmpeg.org/doxygen/4.1/group__lavfi__buffersink.html#ga359d7d1e42c27ca14c07559d4e9adba7">av_buffersink_set_frame_size</a>()

				Read all input frame queue, <a href="https://ffmpeg.org/doxygen/4.1/libavutil_2fifo_8c.html#a81f4cea70d96846df7111daccc5ecce2">av_fifo_size</a>()
					<a href="https://ffmpeg.org/doxygen/4.1/libavutil_2fifo_8c.html#ab708d2f19b7a9592caa278256787adb6">av_fifo_generic_read</a>()
					<a href="https://ffmpeg.org/doxygen/4.1/group__lavfi__buffersrc.html#ga8fc71cb48c1ad1aa78b48f87daa4cf19">av_buffersrc_add_frame</a>()
					av_frame_free

				/* send the EOFs for the finished inputs */
				<a href="https://ffmpeg.org/doxygen/4.1/group__lavfi__buffersrc.html#ga8fc71cb48c1ad1aa78b48f87daa4cf19">av_buffersrc_add_frame</a>()

				/* process queued up subtitle packets */
					<a href="https://ffmpeg.org/doxygen/4.1/libavutil_2fifo_8c.html#ab708d2f19b7a9592caa278256787adb6">av_fifo_generic_read</a>()
					sub2video_update()
					<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__core.html#gaa2c3e02a761d9fc0c5c9b2340408c332">avsubtitle_free</a>()
				On any fail,
					cleanup_filtergraph() // Calls same as above

			/*
			 * Similar case to the early audio initialization in reap_filters.
			 * Audio is special in ffmpeg.c currently as we depend on lavfi's
			 * audio frame buffering/creation to get the output audio frame size
			 * in samples correct. The audio frame size for the filter chain is
			 * configured during the output stream initialization.
			 *
			 * Apparently avfilter_graph_request_oldest (called in
			 * transcode_from_filter just down the line) peeks. Peeking already
			 * puts one frame "ready to be given out", which means that any
			 * update in filter buffer sink configuration afterwards will not
			 * help us. And yes, even if it would be utilized,
			 * av_buffersink_get_samples is affected, as it internally utilizes
			 * the same early exit for peeked frames.
			 *
			 * In other words, if avfilter_graph_request_oldest would not make
			 * further filter chain configuration or usage of
			 * av_buffersink_get_samples useless (by just causing the return
			 * of the peeked AVFrame as-is), we could get rid of this additional
			 * early encoder initialization.
			 */
			 ffmpeg.c::init_output_stream_wrapper() // Same calls as above

			 /**
			 * Perform a step of transcoding for the specified filter graph.
			 *
			 * @param[in]  graph     filter graph to consider
			 * @param[out] best_ist  input stream where a frame would allow to continue
			 * @return  0 for success, <0 for error
			 */
			 ffmpeg.c::transcode_from_filter()
				<a href="https://ffmpeg.org/doxygen/4.1/group__lavfi.html#gab20535e0685fb5f9b4f02e436412c3f0">avfilter_graph_request_oldest</a>()
				/**
				 * Get and encode new output from any of the filtergraphs, without causing
				 * activity.
				 *
				 * @return  0 for success, <0 for severe errors
				 */
				ffmpeg.c::reap_filters()
					AUD:
						ffmpeg.c::init_output_stream_wrapper() // Same Calls as before

					<a href="https://ffmpeg.org/doxygen/4.1/group__lavfi__buffersink.html#ga71ae9c529c8da51681e12faa37d1a395">av_buffersink_get_frame_flags</a>()
					
					VID:
						ffmpeg.c::do_video_out()
							ffmpeg.c::init_output_stream_wrapper() // Same Calls as before
							ffmpeg.c::adjust_frame_pts_to_encoder_tb()
								<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__math.html#gaf02994a8bbeaa91d4757df179cbe567f">av_rescale_q</a>(pts,etc...)

							<a href="https://ffmpeg.org/doxygen/4.1/group__lavfi__buffersink__accessors.html#ga55614fd28de2fa05b04f427390061d5b">av_buffersink_get_frame_rate</a>()

							// Keyframe settings, pts, dts, SYNC Settings, Calculations

							<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__decoding.html#ga9395cb802a5febf1f00df31497779169">avcodec_send_frame</a>()
							<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__frame.html#ga132d6c01d0a21e5b48b96cd7c988de91">av_frame_remove_side_data</a>()

							<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__decoding.html#ga5b8eff59cf259747cf0b31563e38ded6">avcodec_receive_packet</a>()
							<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__packet.html#gae5c86e4d93f6e7aa62ef2c60763ea67e">av_packet_rescale_ts</a>()

							/*
							 * Send a single packet to the output, applying any bitstream filters
							 * associated with the output stream.  This may result in any number
							 * of packets actually being written, depending on what bitstream
							 * filters are applied.  The supplied packet is consumed and will be
							 * blank (as if newly-allocated) when this function returns.
							 *
							 * If eof is set, instead indicate EOF to all bitstream filters and
							 * therefore flush any delayed packets to the output.  A blank packet
							 * must be supplied in this case.
							 */
							ffmpeg.c::output_packet()
								/* apply the output bitstream filters */
								<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__misc.html#gaada9ea8f08d3dcf23c14564dbc88992c">av_bsf_send_packet</a>()
								<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__misc.html#ga7fffb6c87b91250956e7a2367af56b38">av_bsf_receive_packet</a>()
									write_packet() // Same Calls as above

							<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__frame.html#ga0a2b687f9c1c5ed0089b01fd61227108">av_frame_unref</a>()
					AUD:
						ffmpeg.c::do_audio_out()
							<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__packet.html#gac9cb9756175b96e7441575803757fb73">av_init_packet</a>()

							ffmpeg.c::adjust_frame_pts_to_encoder_tb() // Same calls as above
							ffmpeg.c::check_recording_time()
								close_output_stream() // Same calls as above

							// Update pts, opts, frames, etc, etc..

							<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__decoding.html#ga9395cb802a5febf1f00df31497779169">avcodec_send_frame</a>()

							<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__decoding.html#ga5b8eff59cf259747cf0b31563e38ded6">avcodec_receive_packet</a>()
							<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__packet.html#gae5c86e4d93f6e7aa62ef2c60763ea67e">av_packet_rescale_ts</a>()

							output_packet() // Same calls as above
					<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__frame.html#ga0a2b687f9c1c5ed0089b01fd61227108">av_frame_unref</a>()
			/*
			 * Return
			 * - 0 -- one packet was read and processed
			 * - <a href="https://ffmpeg.org/doxygen/4.1/group__lavu__error.html#gae4bb6f165973d09584e0ec0f335f69ca">AVERROR</a>(EAGAIN) -- no packets were available for selected file,
			 *   this function should be called again
			 * - AVERROR_EOF -- this function should not be called again
			 */
			ffmpeg.c::process_input()
				ffmpeg.c::get_input_packet()
					<a href="https://ffmpeg.org/doxygen/4.1/group__lavf__decoding.html#ga4fdb3084415a82e3810de6ee60e46a61">av_read_frame</a>()

				/* pkt = NULL means EOF (needed to flush decoder buffers) */
				ffmpeg.c::process_input_packet()

					<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__packet.html#gac9cb9756175b96e7441575803757fb73">av_init_packet</a>()
					<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__math.html#gaf02994a8bbeaa91d4757df179cbe567f">av_rescale_q</a>(dts, ...)

					AUD:
						ffmpeg.c::decode_audio()
							/* This does not quite work like avcodec_decode_audio4/avcodec_decode_video2.
							 * There is the following difference: if you got a frame, you must call
							 * it again with pkt=NULL. pkt==NULL is treated differently from pkt->size==0
							 *(pkt==NULL means get more output, pkt->size==0 is a flush/drain packet)
							 */
							ffmpeg.c::decode()
								<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__decoding.html#ga58bc4bf1e0ac59e27362597e467efff3">avcodec_send_packet</a>()
								<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__decoding.html#ga11e6542c4e66d3028668788a1a74217c">avcodec_receive_frame</a>()
							ffmpeg.c::check_decode_result()
								exit_program(1)

							// Update timeBases, pts, dts, sample rates etc...
							ffmpeg.c::send_frame_to_filters()
								<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__frame.html#ga88b0ecbc4eb3453eef3fbefa3bddeb7c">av_frame_ref</a>()
								ffmpeg.c::ifilter_send_frame()
									ffmpeg_filter.c::ifilter_parameters_from_frame()

									/* (re)init the graph if possible, otherwise buffer the frame and return */
									<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__frame.html#ga46d6d32f6482a3e9c19203db5877105b">av_frame_clone</a>()
									<a href="https://ffmpeg.org/doxygen/4.1/libavutil_2fifo_8c.html#aeaf7aa802f3b18fef86bb72445eff5d8">av_fifo_realloc2</a>()
									<a href="https://ffmpeg.org/doxygen/4.1/libavutil_2fifo_8c.html#ae95c15dcdd266b4005f8919e4f571180">av_fifo_generic_write</a>()

									ffmpeg.c::reap_filters() // calls same as above

									ffmpeg_filters.c::configure_filtergraph() // CSAA

									<a href="https://ffmpeg.org/doxygen/4.1/group__lavfi__buffersrc.html#ga73ed90c3c3407f36e54d65f91faaaed9">av_buffersrc_add_frame_flags</a>(AV_BUFFERSRC_FLAG_PUSH)
							<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__frame.html#ga0a2b687f9c1c5ed0089b01fd61227108">av_frame_unref</a>()
					VID:
						ffmpeg.c::decode_video()
							<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__frame.html#gac700017c5270c79c1e1befdeeb008b2f">av_frame_alloc</a>()
							<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__math.html#gaf02994a8bbeaa91d4757df179cbe567f">av_rescale_q</a>(Timebase)

							<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__mem__funcs.html#gaadc230ece36ef112710b262a6601a16b">av_realloc_array</a>()
							ffmpeg.c::decode() // CSAA
							ffmpeg.c::check_decode_result() // CSAA

							ffmpeg_hw.c::hwaccel_retrieve_data()
								<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__frame.html#gac700017c5270c79c1e1befdeeb008b2f">av_frame_alloc</a>()
								<a href="https://ffmpeg.org/doxygen/4.1/hwcontext_8c.html#abf1b1664b8239d953ae2cac8b643815a">av_hwframe_transfer_data</a>()
								<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__frame.html#gab9b275b114ace0db95c5796bc71f3012">av_frame_copy_props</a>()

								<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__frame.html#ga0a2b687f9c1c5ed0089b01fd61227108">av_frame_unref</a>()
								<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__frame.html#ga709e62bc2917ffd84c5c0f4e1dfc48f7">av_frame_move_ref</a>()
								<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__frame.html#ga979d73f3228814aee56aeca0636e37cc">av_frame_free</a>()

								on Fail,
									<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__frame.html#ga979d73f3228814aee56aeca0636e37cc">av_frame_free</a>()

							// Set pts, dts, timestams, etc..
							<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__math.html#gaf02994a8bbeaa91d4757df179cbe567f">av_rescale_q</a>(pts)

							ffmpeg.c::send_frame_to_filters() // CSAA

							On fail,
								<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__frame.html#ga0a2b687f9c1c5ed0089b01fd61227108">av_frame_unref</a>()
						// Set framerates, next dts, etc etc...
					SUBTITLES:
						ffmpeg.c::transcode_subtitles()
							<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__decoding.html#ga47db1b7f294b9f92684401b9c66a7c4b">avcodec_decode_subtitle2</a>()
							ffmpeg.c::check_decode_result()

							on Fail,
								ffmpeg.c::sub2video_flush()
									ffmpeg.c::sub2video_update()
										ffmpeg.c::sub2video_copy_rect()
										ffmpeg.c::sub2video_push_ref()
									<a href="https://ffmpeg.org/doxygen/4.1/group__lavfi__buffersrc.html#ga8fc71cb48c1ad1aa78b48f87daa4cf19">av_buffersrc_add_frame</a>(NULL)

							<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__math.html#ga3daf97178dd1b08b5e916be381cd33e4">av_rescale</a>(pts)
							ffmpeg.c::sub2video_update()
							<a href="https://ffmpeg.org/doxygen/4.1/libavutil_2fifo_8c.html#adae9b18c5eed14fe851c5bb984ce374b">av_fifo_alloc</a>()
							<a href="https://ffmpeg.org/doxygen/4.1/libavutil_2fifo_8c.html#aeaf7aa802f3b18fef86bb72445eff5d8">av_fifo_realloc2</a>()
							<a href="https://ffmpeg.org/doxygen/4.1/libavutil_2fifo_8c.html#ae95c15dcdd266b4005f8919e4f571180">av_fifo_generic_write</a>()

							ffmpeg.c::do_subtitle_out()
								<a href="https://ffmpeg.org/doxygen/4.1/tableprint__vlc_8h.html#ae97db1f58b6b1515ed57a83bea3dd572">av_malloc</a>()
								<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__math.html#gaf02994a8bbeaa91d4757df179cbe567f">av_rescale_q</a>(pts)
								<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__encoding.html#ga37be256d85d78f665df27ad6c8f1d65b">avcodec_encode_subtitle</a>()
								<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__packet.html#gac9cb9756175b96e7441575803757fb73">av_init_packet</a>()
								ffmpeg.c::output_packet() // CSAA

					/* after flushing, send an EOF on all the filter inputs attached to the stream */
					/* except when looping we need to flush but not to send an EOF */
					ffmpeg.c::send_filter_eof()
						ffmpeg.c::ifilter_send_eof()
							<a href="https://ffmpeg.org/doxygen/4.1/group__lavfi__buffersrc.html#ga828fc86955dc0530ea53c123862e3da6">av_buffersrc_close</a>()
							ffmpeg.c::ifilter_parameters_from_codecpar()

					/* handle stream copy */
					// Set pts, dts, etc..
					ffmpeg.c::do_streamcopy()
						<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__packet.html#gac9cb9756175b96e7441575803757fb73">av_init_packet</a>()
						output_packet(NULL) // flush

						if past recoding time, cli, 
							ffmpeg.c::close_output_stream() // CSAA

						// force the input stream PTS and other ptd, dts, settings
						AUD:
							<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__misc.html#ga3266a8c3df0790c62259f91afcde45a9">av_get_audio_frame_duration</a>()
							<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__math.html#ga29b7c3d60d68ef678ee1f4adc61a25dc">av_rescale_delta</a>()

						ffmpeg.c::output_packet() // CSAA

				<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__misc.html#gaf60b0e076f822abcb2700eb601d352a6">avcodec_flush_buffers</a>()

				ffmpeg.c::seek_to_start()
					<a href="https://ffmpeg.org/doxygen/4.1/group__lavf__decoding.html#ga3b40fc8d2fda6992ae6ea2567d71ba30">avformat_seek_file</a>()
					<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__math.html#gaf02994a8bbeaa91d4757df179cbe567f">av_rescale_q</a>()
					// Set samples, framerates, duration, etc...

				ffmpeg.c::get_input_packet() // CSAA
				ffmpeg.c::process_input_packet() // CSAA

				/* mark all outputs that don't go through lavfi as finished */
				ffmpeg.c::finish_output_stream()
				
				ffmpeg.c::reset_eagain()

				// WRAP_CORRECTION Correcting starttime based on the enabled streams
				// Settings related to pts, dts, startime, etc, etc..

				/* add the stream-global side data to the first packet */
					<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__packet.html#ga77a800026abd6dc2f4ac1e0ad7e3e999">av_packet_get_side_data</a>()
					<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__packet.html#gac59f9714ac34774b43b3797c80b06c68">av_packet_new_side_data</a>()
					memcpy()

				// Dispositon correction.. etc...Settings related to pts, dts, startime, etc, etc..

				ffmpeg.c::sub2video_heartbeat()
					/* When a frame is read from a file, examine all sub2video streams in
					   the same file and send the sub2video frame again. Otherwise, decoded
					   video frames could be accumulating in the filter graph while a filter
					   (possibly overlay) is desperately waiting for a subtitle frame. */
					<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__math.html#gaf02994a8bbeaa91d4757df179cbe567f">av_rescale_q</a>()
					ffmpeg.c::sub2video_update() // CSAA
					<a href="https://ffmpeg.org/doxygen/4.1/group__lavfi__buffersrc.html#ga996e96007a0fda870549ac3c4e1e0967">av_buffersrc_get_nb_failed_requests</a>()
					ffmpeg.c::sub2video_push_ref() // CSAA

				ffmpeg.c::process_input_packet() // CSAA

				if discard packet, <a href="https://ffmpeg.org/doxygen/4.1/group__lavc__packet.html#ga63d5a489b419bd5d45cfd09091cbcbc2">av_packet_unref</a>()
		// End of trasncode_step()

		/* at the end of stream, we must flush the decoder buffers */
		ffmpeg.c::process_input_packet(NULL) // CSAA

		ffmpeg.c::flush_encoders()
			ffmpeg.c::finish_output_stream() // CSAA
			ffmpeg.c::init_output_stream_wrapper(NULL) // CSAA

			<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__packet.html#gac9cb9756175b96e7441575803757fb73">av_init_packet</a>(NULL)
			<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__decoding.html#ga5b8eff59cf259747cf0b31563e38ded6">avcodec_receive_packet</a>()
			<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__decoding.html#ga9395cb802a5febf1f00df31497779169">avcodec_send_frame</a>(NULL)

			output_packet(NULL)
			<a href="https://ffmpeg.org/doxygen/4.1/group__lavc__packet.html#ga63d5a489b419bd5d45cfd09091cbcbc2">av_packet_unref</a>()

		ffmpeg_hw.c::hw_device_free_all()
			<a href="https://ffmpeg.org/doxygen/4.1/tableprint__vlc_8h.html#adba82e1bcd02de510a858fcbedf79ef1">av_freep</a>()
			<a href="https://ffmpeg.org/doxygen/4.1/group__lavu__buffer.html#ga135e9e929b5033bb8f68322497b2effc">av_buffer_unref</a>()

		// Free all output streams, dicts
	/// End of transcode()
/// End of main()

</pre>

main()
	cmdutils.c::init_dynload()
		SetDllDirectory("")

	register_exit()
		ffmpeg.c::ffmpeg_cleanup()
			// Free filers FilterGraph with avfilter_graph_free()
				// for each FilterGraph's Input
					av_fifo_generic_read()
					av_frame_free()
					av_fifo_freep()
					avsubtitle_free()
					av_buffer_unref()
					av_freep()
					avfilter_inout_free()

			// Close Files with avio_closep()
				avformat_free_context()
				av_dict_free()
				av_freep()

			// Close Output Streams av_bsf_free()
				av_frame_free()
				av_frame_free()
				av_dict_free()

				av_freep()
				av_expr_free()
				av_freep()

				avcodec_free_context()
				avcodec_parameters_free()

				av_fifo_generic_read(muxing_queue, &pkt)
				av_packet_unref(&pkt)					
				av_fifo_freep(muxing_queue)

			free_input_threads()
				
			// Close input Files avformat_close_input()
				av_freep()

			// Close input Streams
				av_frame_free(decoded_frame)
				av_frame_free(filter_frame)
				av_dict_free(decoder_opts)
				avsubtitle_freesubtitle)
				av_frame_free(sub2video.frame)
				av_freep(filters)
				av_freep(hwaccel_device)
				av_freep(dts_buffer)
				avcodec_free_context(dec_ctx)
				av_freep(input_streams)

			avformat_network_deinit()

	av_log_set_flags()

	// if CONFIG_AVDEVICE set avdevice_register_all();

	avformat_network_init()

	ffmpeg_opt.c::ffmpeg_parse_options()
		options = cmdutils.c::split_commandline() /* split the commandline into an internal representation */
			cmdutils.c::prepare_app_arguments() /* perform system-dependent conversions for arguments list */
			cmdutils.c::init_parse_context() 
				cmdutils.c::init_opts() 
					av_dict_set()
		cmdutils.c::parse_optgroup("GLOABAL")

		cmdutils.c::open_files()
			ffmpeg_opt.c::open_input_file()
				// Check if supported file format with 
				libavformat::av_find_input_format()
				inputContext = libavformat::avformat_alloc_context()
				av_dict_set_int() /* Setting global Opts as per Input file opts */
				find_codec_or_die()
					avcodec_find_encoder_by_name()
				// Set inputContext's members as per codec
				libavformat::avformat_open_input()
				libavformat::avformat_find_stream_info()
				// if specified in cmd line options, avformat_seek_file()
				ffmpeg_opt.c::add_input_streams()/* Add all the streams from the given input file to the global list of input streams. */
					dec_Context = avcodec_alloc_context3()
					avcodec_parameters_to_context(dec_Context, cmdLineParameters)
						// Based on Codec_Type (VID, AUD, SUB, etc, etc)
							VID:
							avcodec_find_decoder()
								// Specific to HwAccelearation 
									av_get_pix_fmt()
									av_hwdevice_find_type_by_name()
							AUD:
							ffmpeg.c::guess_input_channel_layout()
								av_get_default_channel_layout()
								av_get_channel_layout_string()
							DATA, SUB:
							avcodec_find_decoder()
							ATTACHMENT, UNKNOWN:
							// Do Nothing here
					avcodec_parameters_from_context()
				av_dump_format()
		ffmpeg_opt.c::init_complex_filters()
			ffmpeg_filter.c::init_complex_filtergraph()
				avfilter_graph_alloc()
				avfilter_graph_parse2()
					on fail,
						avfilter_inout_free();
						avfilter_graph_free();
				For all Inputs,
					ffmpeg_filter.c::init_input_filter()
						avfilter_pad_get_type()
							cmdutils.c::check_stream_specifier()
								avformat_match_stream_specifier()
						av_fifo_alloc()
				For all outputs,
					av_mallocz()
					avfilter_pad_get_type()
					ffmpeg_filter.c::describe_filter_link()
						avio_open_dyn_buf()
						avio_printf()
						avio_w8()
						avio_close_dyn_buf()
		cmdutils.c::open_files()
			ffmpeg_opt.c::open_output_file()
				// if no Stream maps
					avformat_alloc_output_context2()	
					av_dict_get()
					av_opt_find()
					av_opt_eval_flags()
				
					/* create streams for all unlabeled output pads */
					ffmpeg_opt.c::init_output_filter()
						// Based on Type
						VID:
							ffmpeg_opt.c::new_video_stream()
								ffmpeg_opt.c::new_output_stream()
									avformat_new_stream()
									av_mallocz()
									ffmpeg_opt.c::choose_encoder()
										av_guess_codec()
										avcodec_find_encoder()
									avcodec_alloc_context3()
									avcodec_parameters_alloc()
									ffmpeg_opt.c::get_preset_file_2()
										av_dict_set()
										av_free()
										avio_closep();
									av_parse_ratio() // for Timebase and enc_Timebase
									// Parse and Set options
								av_parse_video_rate()
								av_parse_ratio() // for AspectRatio
								av_parse_video_size()
								av_get_pix_fmt()
								av_fopen_utf8() // log file
								ffmpeg_opt.c::get_ost_filters()
									read_file() //read filter script from file
										avio_open()
										avio_open_dyn_buf()
										avio_read()
										avio_write()
										avio_w8()
										avio_closep()
										avio_close_dyn_buf()
									or get from CmdLine av_strdup()
						AUD:
							ffmpeg_opt.c::new_audio_stream()
								ffmpeg_opt.c::new_output_stream() // Same calls as above incase of VID
							av_get_sample_fmt()
							get_ost_filters()
							av_reallocp_array()
						avfilter_inout_free()
					// Based on Type (VID, AUD)
					VID:
						av_guess_codec()
						avformat_query_codec()
						ffmpeg_opt.c::new_video_stream() // Same calls as above
					AUD:
						av_guess_codec()
						ffmpeg_opt.c::new_audio_stream() // Same calls as above
					SUBTITLE:
						avcodec_find_encoder()
						avcodec_descriptor_get()
						ffmpeg_opt.c::new_subtitle_stream()
							ffmpeg_opt.c::new_output_stream() // Same Calls as above
					DATA:
						av_guess_codec()
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
				avio_open2()
				av_malloc()
				avio_read()
				ffmpeg_opt.c::new_attachment_stream()
				av_dict_set()
				avio_closep()
			// Set options

			/* set the decoding_needed flags and create simple filtergraphs */
			ffmpeg_opt.c::init_simple_filtergraph()
			// set the filter output constraints

			avio_open2()

			// copy metadata
			// copy chapters
			// copy global metadata by default

			// process manually set programs
			av_new_program()
		on fail, uninit_parse_context()

	/* The following code is the main loop of the file converter */
	ffmpeg.c::transcode()
		ffmpeg.c::transcode_init()
			//Link FilterGraphs and OutputFilter

			/* init framerate emulation */
			InputFile.InputStreams = av_gettime_relative()

			/* init input streams */
			ffmpeg.c::init_input_stream()
				/* Set Dec_Context Options */
				av_opt_set_int()
				av_dict_set()
				ffmpeg_hw.c::hw_device_setup_for_decode()
					ffmpeg_hw.c::hw_device_get_by_name()
					ffmpeg_hw.c::hw_device_init_from_type()
						ffmpeg_hw.c::hw_device_default_name()
							av_hwdevice_get_type_name()							
						av_hwdevice_ctx_create()
						ffmpeg_hw.c::hw_device_add()
							av_reallocp_array(hw_devices)
							av_mallocz()
						On fail, av_freep() & av_buffer_unref()
					if Generic HWACCEL_AUTO Device, 
						hw_device_match_by_codec()
						avcodec_get_hw_config()
						hw_device_init_from_type()
				avcodec_open2()
			On fail init_input_stream(), Close all Encoding contexts with avcodec_close()
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
								av_buffersink_get_format()
								av_get_bytes_per_sample()
								av_buffersink_get_sample_rate()
								av_buffersink_get_channel_layout()
								av_buffersink_get_channels()

								ffmpeg.c::init_encoder_time_base() // Based on SampleRate
							VID:
								ffmpeg.c::init_encoder_time_base() // Based on frameRate
								av_buffersink_get_time_base()
								av_buffersink_get_w()
								av_buffersink_get_h()
								av_buffersink_get_sample_aspect_ratio()

								av_buffersink_get_format()
								av_pix_fmt_desc_get()

								// Set other options on Enc_Context
							SUB: // Set options
							DATA: // Set Options
						ffmpeg_hw.c::hw_device_setup_for_encode()
							av_buffersink_get_hw_frames_ctx()
							avcodec_get_hw_config()
							// Set Enc_Context Options
						avcodec_descriptor_get(deCodecContext)
						avcodec_descriptor_get(OutputStream)

						avcodec_open2()
						av_buffersink_set_frame_size()
						avcodec_parameters_from_context(ost->st->codecpar, ost->enc_ctx)
						avcodec_copy_context(ost->st->codec, ost->enc_ctx)
						/* if has coded_side_data, */
							av_stream_new_side_data()
							av_display_rotation_set()
					/* else if StreamCopy */
						ffmpeg.c::init_output_stream_streamcopy()
							avcodec_parameters_to_context()
							avcodec_parameters_from_context()
							avcodec_parameters_copy()

							avformat_transfer_internal_stream_timing_info()

							// copy timebase while removing common factors
							// copy estimated duration as a hint to the muxer
							// copy disposition

							av_stream_new_side_data()
							// Set options on OutputStream

					// parse user provided disposition, and update stream values
					
					/* initialize bitstream filters for the output stream
					 * needs to be done here, because the codec id for streamcopy is not
					 * known until now */
					ffmpeg.c::init_output_bsfs()
						avcodec_parameters_copy()
						av_bsf_init()

					/* open the muxer when all the streams are initialized */
					ffmpeg.c::check_init_output_file()
						OuputFile->interrupt_callback = int_cb;
						avformat_write_header()

						/* flush the muxing queues */
						/* try to improve muxing time_base (only possible if nothing has been written yet) */
						av_fifo_size()
						av_fifo_generic_read()
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
								av_fifo_space()
								av_fifo_realloc2()
								av_packet_make_refcounted()
								av_packet_move_ref()
								av_fifo_generic_write()

							VID:
								av_packet_get_side_data()
							
							av_packet_rescale_ts()

							// set pts, dts

							av_interleaved_write_frame()
							av_packet_unref()
			// discard unused programs

			/* write headers for files with no streams */
			check_init_output_file() // Same calls as above

			// dump the stream mapping

		/// end transcode_init()

		/* Return 1 if there remain streams where more output is wanted, 0 otherwise. */
		ffmpeg.c::need_output()
			close_output_stream()
				av_rescale_q()

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
				av_rescale_q()

			if ffmpeg.c::got_eagain()
			ffmpeg.c::reset_eagain()
			// return 0 // Stop FFMPEG

			ffmpeg.c::ifilter_has_all_input_formats()
			ffmpeg_filter.c::configure_filtergraph()
				ffmpeg_filter.c::cleanup_filtergraph()
					// Null Output and Input filters
					avfilter_graph_free()

				avfilter_graph_alloc()

				av_dict_get()
				av_strlcatf()

				avfilter_graph_parse2()

				ffmpeg_hw.c::hw_device_setup_for_filter()
					av_buffer_ref()

				avfilter_inout_free()
				avfilter_graph_set_auto_convert()
				avfilter_graph_config()

                /* limit the lists of allowed formats to the ones selected, to
                 * make sure they stay the same if the filtergraph is reconfigured later */
					av_buffersink_get_format()
					av_buffersink_get_w()
					av_buffersink_get_h()
					av_buffersink_get_sample_rate()
					av_buffersink_get_channel_layout()

				AUD: and AV_CODEC_CAP_VARIABLE_FRAME_SIZE = 0
					av_buffersink_set_frame_size()

				Read all input frame queue, av_fifo_size()
					av_fifo_generic_read()
					av_buffersrc_add_frame()
					av_frame_free

				/* send the EOFs for the finished inputs */
				av_buffersrc_add_frame()

				/* process queued up subtitle packets */
					av_fifo_generic_read()
					sub2video_update()
					avsubtitle_free()
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
				avfilter_graph_request_oldest()
				/**
				 * Get and encode new output from any of the filtergraphs, without causing
				 * activity.
				 *
				 * @return  0 for success, <0 for severe errors
				 */
				ffmpeg.c::reap_filters()
					AUD:
						ffmpeg.c::init_output_stream_wrapper() // Same Calls as before

					av_buffersink_get_frame_flags()
					
					VID:
						ffmpeg.c::do_video_out()
							ffmpeg.c::init_output_stream_wrapper() // Same Calls as before
							ffmpeg.c::adjust_frame_pts_to_encoder_tb()
								av_rescale_q(pts,etc...)

							av_buffersink_get_frame_rate()

							// Keyframe settings, pts, dts, SYNC Settings, Calculations

							avcodec_send_frame()
							av_frame_remove_side_data()

							avcodec_receive_packet()
							av_packet_rescale_ts()

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
								av_bsf_send_packet()
								av_bsf_receive_packet()
									write_packet() // Same Calls as above

							av_frame_unref()
					AUD:
						ffmpeg.c::do_audio_out()
							av_init_packet()

							ffmpeg.c::adjust_frame_pts_to_encoder_tb() // Same calls as above
							ffmpeg.c::check_recording_time()
								close_output_stream() // Same calls as above

							// Update pts, opts, frames, etc, etc..

							avcodec_send_frame()

							avcodec_receive_packet()
							av_packet_rescale_ts()

							output_packet() // Same calls as above
					av_frame_unref()
			/*
			 * Return
			 * - 0 -- one packet was read and processed
			 * - AVERROR(EAGAIN) -- no packets were available for selected file,
			 *   this function should be called again
			 * - AVERROR_EOF -- this function should not be called again
			 */
			ffmpeg.c::process_input()
				ffmpeg.c::get_input_packet()
					av_read_frame()

				/* pkt = NULL means EOF (needed to flush decoder buffers) */
				ffmpeg.c::process_input_packet()

					av_init_packet()
					av_rescale_q(dts, ...)

					AUD:
						ffmpeg.c::decode_audio()
							/* This does not quite work like avcodec_decode_audio4/avcodec_decode_video2.
							 * There is the following difference: if you got a frame, you must call
							 * it again with pkt=NULL. pkt==NULL is treated differently from pkt->size==0
							 *(pkt==NULL means get more output, pkt->size==0 is a flush/drain packet)
							 */
							ffmpeg.c::decode()
								avcodec_send_packet()
								avcodec_receive_frame()
							ffmpeg.c::check_decode_result()
								exit_program(1)

							// Update timeBases, pts, dts, sample rates etc...
							ffmpeg.c::send_frame_to_filters()
								av_frame_ref()
								ffmpeg.c::ifilter_send_frame()
									ffmpeg_filter.c::ifilter_parameters_from_frame()

									/* (re)init the graph if possible, otherwise buffer the frame and return */
									av_frame_clone()
									av_fifo_realloc2()
									av_fifo_generic_write()

									ffmpeg.c::reap_filters() // calls same as above

									ffmpeg_filters.c::configure_filtergraph() // CSAA

									av_buffersrc_add_frame_flags(AV_BUFFERSRC_FLAG_PUSH)
							av_frame_unref()
					VID:
						ffmpeg.c::decode_video()
							av_frame_alloc()
							av_rescale_q(Timebase)

							av_realloc_array()
							ffmpeg.c::decode() // CSAA
							ffmpeg.c::check_decode_result() // CSAA

							ffmpeg_hw.c::hwaccel_retrieve_data()
								av_frame_alloc()
								av_hwframe_transfer_data()
								av_frame_copy_props()

								av_frame_unref()
								av_frame_move_ref()
								av_frame_free()

								on Fail,
									av_frame_free()

							// Set pts, dts, timestams, etc..
							av_rescale_q(pts)

							ffmpeg.c::send_frame_to_filters() // CSAA

							On fail,
								av_frame_unref()
						// Set framerates, next dts, etc etc...
					SUBTITLES:
						ffmpeg.c::transcode_subtitles()
							avcodec_decode_subtitle2()
							ffmpeg.c::check_decode_result()

							on Fail,
								ffmpeg.c::sub2video_flush()
									ffmpeg.c::sub2video_update()
										ffmpeg.c::sub2video_copy_rect()
										ffmpeg.c::sub2video_push_ref()
									av_buffersrc_add_frame(NULL)

							av_rescale(pts)
							ffmpeg.c::sub2video_update()
							av_fifo_alloc()
							av_fifo_realloc2()
							av_fifo_generic_write()

							ffmpeg.c::do_subtitle_out()
								av_malloc()
								av_rescale_q(pts)
								avcodec_encode_subtitle()
								av_init_packet()
								ffmpeg.c::output_packet() // CSAA

					/* after flushing, send an EOF on all the filter inputs attached to the stream */
					/* except when looping we need to flush but not to send an EOF */
					ffmpeg.c::send_filter_eof()
						ffmpeg.c::ifilter_send_eof()
							av_buffersrc_close()
							ffmpeg.c::ifilter_parameters_from_codecpar()

					/* handle stream copy */
					// Set pts, dts, etc..
					ffmpeg.c::do_streamcopy()
						av_init_packet()
						output_packet(NULL) // flush

						if past recoding time, cli, 
							ffmpeg.c::close_output_stream() // CSAA

						// force the input stream PTS and other ptd, dts, settings
						AUD:
							av_get_audio_frame_duration()
							av_rescale_delta()

						ffmpeg.c::output_packet() // CSAA

				avcodec_flush_buffers()

				ffmpeg.c::seek_to_start()
					avformat_seek_file()
					av_rescale_q()
					// Set samples, framerates, duration, etc...

				ffmpeg.c::get_input_packet() // CSAA
				ffmpeg.c::process_input_packet() // CSAA

				/* mark all outputs that don't go through lavfi as finished */
				ffmpeg.c::finish_output_stream()
				
				ffmpeg.c::reset_eagain()

				// WRAP_CORRECTION Correcting starttime based on the enabled streams
				// Settings related to pts, dts, startime, etc, etc..

				/* add the stream-global side data to the first packet */
					av_packet_get_side_data()
					av_packet_new_side_data()
					memcpy()

				// Dispositon correction.. etc...Settings related to pts, dts, startime, etc, etc..

				ffmpeg.c::sub2video_heartbeat()
					/* When a frame is read from a file, examine all sub2video streams in
					   the same file and send the sub2video frame again. Otherwise, decoded
					   video frames could be accumulating in the filter graph while a filter
					   (possibly overlay) is desperately waiting for a subtitle frame. */
					av_rescale_q()
					ffmpeg.c::sub2video_update() // CSAA
					av_buffersrc_get_nb_failed_requests()
					ffmpeg.c::sub2video_push_ref() // CSAA

				ffmpeg.c::process_input_packet() // CSAA

				if discard packet, av_packet_unref()
		// End of trasncode_step()

		/* at the end of stream, we must flush the decoder buffers */
		ffmpeg.c::process_input_packet(NULL) // CSAA

		ffmpeg.c::flush_encoders()
			ffmpeg.c::finish_output_stream() // CSAA
			ffmpeg.c::init_output_stream_wrapper(NULL) // CSAA

			av_init_packet(NULL)
			avcodec_receive_packet()
			avcodec_send_frame(NULL)

			output_packet(NULL)
			av_packet_unref()

		ffmpeg_hw.c::hw_device_free_all()
			av_freep()
			av_buffer_unref()

		// Free all output streams, dicts
	/// End of transcode()
/// End of main()
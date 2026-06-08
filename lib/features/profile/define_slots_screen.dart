part of '../../main.dart';

class DefineSlotsScreen extends StatefulWidget {
  const DefineSlotsScreen({super.key});

  @override
  State<DefineSlotsScreen> createState() => _DefineSlotsScreenState();
}

class _DefineSlotsScreenState extends State<DefineSlotsScreen> {
  // Mock Video Player State
  bool _isPlaying = false;
  double _currentPlaybackTime = 0.0;
  Timer? _playbackTimer;

  // List of Slots
  final List<SlotModel> _slots = [
    SlotModel(
      id: '1',
      name: 'Bride Video',
      type: 'Video',
      icon: Icons.videocam_outlined,
      start: 0.0,
      end: 5.0,
      color: EditoColors.primary,
      tintColor: const Color(0xFFF1ECFF),
      borderColors: const Color(0xFFDCD6FF),
    ),
    SlotModel(
      id: '2',
      name: 'Groom Video',
      type: 'Video',
      icon: Icons.videocam_outlined,
      start: 5.0,
      end: 10.0,
      color: const Color(0xFF2196F3),
      tintColor: const Color(0xFFE3F2FD),
      borderColors: const Color(0xFFBBDEFB),
    ),
    SlotModel(
      id: '3',
      name: 'Couple Photo',
      type: 'Image',
      icon: Icons.image_outlined,
      start: 10.0,
      end: 15.0,
      color: const Color(0xFF1BB676),
      tintColor: const Color(0xFFE8F8EF),
      borderColors: const Color(0xFFC6F2D6),
    ),
    SlotModel(
      id: '4',
      name: 'Name Text',
      type: 'Text',
      icon: Icons.text_fields_rounded,
      start: 15.0,
      end: 20.0,
      color: const Color(0xFFFF9800),
      tintColor: const Color(0xFFFFF2DE),
      borderColors: const Color(0xFFFFE0B2),
    ),
    SlotModel(
      id: '5',
      name: 'Logo',
      type: 'Image/Logo',
      icon: Icons.auto_awesome_rounded,
      start: 20.0,
      end: 30.0,
      color: const Color(0xFFE91E63),
      tintColor: const Color(0xFFFEEBF6),
      borderColors: const Color(0xFFF8BBD0),
    ),
  ];

  @override
  void dispose() {
    _playbackTimer?.cancel();
    super.dispose();
  }

  void _togglePlayback() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      _playbackTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        setState(() {
          _currentPlaybackTime += 0.1;
          if (_currentPlaybackTime >= 30.0) {
            _currentPlaybackTime = 0.0;
            _isPlaying = false;
            _playbackTimer?.cancel();
          }
        });
      });
    } else {
      _playbackTimer?.cancel();
    }
  }

  void _handleContinue() {
    _playbackTimer?.cancel();
    setState(() {
      _isPlaying = false;
    });

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const TemplateSubmittedScreen(),
      ),
    );
  }

  void _showPreviewNotification() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Generating high fidelity preview...',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Delete Slot & Manage Contiguity
  void _deleteSlot(SlotModel slot) {
    final index = _slots.indexWhere((s) => s.id == slot.id);
    if (index == -1) return;

    final deletedSlot = _slots[index];
    setState(() {
      _slots.removeAt(index);
      if (_slots.isNotEmpty) {
        if (index == 0) {
          _slots[0].start = 0.0;
        } else if (index == _slots.length) {
          _slots[_slots.length - 1].end = 30.0;
        } else {
          _slots[index - 1].end = deletedSlot.end;
        }
      }
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted "${deletedSlot.name}"'),
        action: SnackBarAction(
          label: 'Undo',
          textColor: EditoColors.primary,
          onPressed: () {
            setState(() {
              _slots.insert(index, deletedSlot);
              if (index == 0 && _slots.length > 1) {
                _slots[1].start = deletedSlot.end;
              } else if (index == _slots.length - 1 && _slots.length > 1) {
                _slots[_slots.length - 2].end = deletedSlot.start;
              } else if (index > 0 && index < _slots.length - 1) {
                _slots[index - 1].end = deletedSlot.start;
                _slots[index + 1].start = deletedSlot.end;
              }
            });
          },
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // Add / Edit Slot Dialog
  void _showSlotFormDialog({SlotModel? slotToEdit}) {
    final bool isEdit = slotToEdit != null;
    final int editIndex = isEdit ? _slots.indexOf(slotToEdit) : -1;

    final nameController = TextEditingController(text: isEdit ? slotToEdit.name : '');
    String selectedType = isEdit ? slotToEdit.type : 'Video';

    // Time ranges constraints
    double minAllowed = 0.0;
    double maxAllowed = 30.0;
    double currentStart = 0.0;
    double currentEnd = 5.0;

    if (isEdit) {
      currentStart = slotToEdit.start;
      currentEnd = slotToEdit.end;
      if (editIndex > 0) {
        minAllowed = _slots[editIndex - 1].start + 1.0;
      }
      if (editIndex < _slots.length - 1) {
        maxAllowed = _slots[editIndex + 1].end - 1.0;
      }
    } else {
      // Find a reasonable gap or place at the end of the last slot
      if (_slots.isNotEmpty) {
        double lastEnd = _slots.last.end;
        if (lastEnd < 30.0) {
          currentStart = lastEnd;
          currentEnd = 30.0;
          minAllowed = lastEnd;
        } else {
          // Splitting the last slot in half to accommodate the new one
          double splitPoint = lastEnd - 4.0;
          if (splitPoint > _slots.last.start + 2.0) {
            currentStart = splitPoint;
            currentEnd = 30.0;
            minAllowed = _slots.last.start + 1.0;
          } else {
            currentStart = 25.0;
            currentEnd = 30.0;
          }
        }
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text(
                isEdit ? 'Edit Replaceable Slot' : 'Add Replaceable Slot',
                style: GoogleFonts.poppins(
                  color: EditoColors.dark,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Slot Name field
                    Text(
                      'Slot Name',
                      style: GoogleFonts.inter(
                        color: EditoColors.dark,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: 'e.g. Groom Close-up',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: EditoColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: EditoColors.primary, width: 1.5),
                        ),
                      ),
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 18),

                    // Slot Type field
                    Text(
                      'Slot Type',
                      style: GoogleFonts.inter(
                        color: EditoColors.dark,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: EditoColors.border),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedType,
                          isExpanded: true,
                          items: <String>['Video', 'Image', 'Text', 'Image/Logo']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setDialogState(() {
                                selectedType = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Timing Adjustment Slider
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Timing Details',
                          style: GoogleFonts.inter(
                            color: EditoColors.dark,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '${currentStart.toStringAsFixed(1)}s - ${currentEnd.toStringAsFixed(1)}s',
                          style: GoogleFonts.inter(
                            color: EditoColors.primary,
                            fontWeight: FontWeight.w800,
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    RangeSlider(
                      values: RangeValues(currentStart, currentEnd),
                      min: minAllowed,
                      max: maxAllowed,
                      activeColor: EditoColors.primary,
                      inactiveColor: const Color(0xFFE4E6F0),
                      labels: RangeLabels(
                        '${currentStart.toStringAsFixed(1)}s',
                        '${currentEnd.toStringAsFixed(1)}s',
                      ),
                      onChanged: (RangeValues newValues) {
                        // Clamp values to ensure duration is at least 1.0 second
                        if (newValues.end - newValues.start >= 1.0) {
                          setDialogState(() {
                            currentStart = newValues.start;
                            currentEnd = newValues.end;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.inter(
                      color: EditoColors.body,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: EditoColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    final nameText = nameController.text.trim();
                    if (nameText.isEmpty) return;

                    // Map types to corresponding styles
                    IconData icon = Icons.videocam_outlined;
                    Color color = EditoColors.primary;
                    Color tint = const Color(0xFFF1ECFF);
                    Color border = const Color(0xFFDCD6FF);

                    if (selectedType == 'Image') {
                      icon = Icons.image_outlined;
                      color = const Color(0xFF1BB676);
                      tint = const Color(0xFFE8F8EF);
                      border = const Color(0xFFC6F2D6);
                    } else if (selectedType == 'Text') {
                      icon = Icons.text_fields_rounded;
                      color = const Color(0xFFFF9800);
                      tint = const Color(0xFFFFF2DE);
                      border = const Color(0xFFFFE0B2);
                    } else if (selectedType == 'Image/Logo') {
                      icon = Icons.auto_awesome_rounded;
                      color = const Color(0xFFE91E63);
                      tint = const Color(0xFFFEEBF6);
                      border = const Color(0xFFF8BBD0);
                    }

                    setState(() {
                      if (isEdit) {
                        // Update existing slot details
                        final target = _slots[editIndex];
                        target.name = nameText;
                        target.type = selectedType;
                        target.icon = icon;
                        target.color = color;
                        target.tintColor = tint;
                        target.borderColors = border;

                        // Align timings
                        target.start = currentStart;
                        target.end = currentEnd;

                        if (editIndex > 0) {
                          _slots[editIndex - 1].end = currentStart;
                        }
                        if (editIndex < _slots.length - 1) {
                          _slots[editIndex + 1].start = currentEnd;
                        }
                      } else {
                        // Add new slot contiguous adjustment
                        final newSlot = SlotModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: nameText,
                          type: selectedType,
                          icon: icon,
                          start: currentStart,
                          end: currentEnd,
                          color: color,
                          tintColor: tint,
                          borderColors: border,
                        );

                        if (_slots.isNotEmpty) {
                          // Insert and scale or move boundaries to keep contiguous
                          _slots.last.end = currentStart;
                        }
                        _slots.add(newSlot);
                        _slots.sort((a, b) => a.start.compareTo(b.start));
                      }
                    });

                    Navigator.of(context).pop();
                  },
                  child: Text(
                    isEdit ? 'Save Changes' : 'Add Slot',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: _SoftBackground()),
          SafeArea(
            bottom: false,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
                  sliver: SliverList.list(
                    children: [
                      // Header Row
                      Row(
                        children: [
                          _UseHeaderButton(
                            icon: Icons.chevron_left_rounded,
                            onTap: () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Define Replaceable Slots',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    color: EditoColors.dark,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    height: 1.15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Review and customize slots in your video',
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    color: EditoColors.body.withValues(alpha: 0.74),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: _showPreviewNotification,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFFDCCCFF)),
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.visibility_outlined,
                                    color: EditoColors.primary,
                                    size: 15,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Preview',
                                    style: GoogleFonts.inter(
                                      color: EditoColors.primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),

                      // Stepper flow indicator
                      const _DefineSlotsSteps(),
                      const SizedBox(height: 25),

                      // Video Info Summary Card
                      const _VideoDetailsInfoCard(),
                      const SizedBox(height: 16),

                      // Video Player Container
                      _InteractiveVideoPlayer(
                        isPlaying: _isPlaying,
                        playbackTime: _currentPlaybackTime,
                        onTogglePlay: _togglePlayback,
                      ),
                      const SizedBox(height: 20),

                      // Timeline and Slots Card
                      _buildTimelineCard(),
                      const SizedBox(height: 16),

                      // Detected Slots List Card
                      _buildSlotsListCard(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Gradient Continue Button (Sticky Overlay)
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: _ContinueButton(
              label: 'Continue',
              onTap: _handleContinue,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Timeline Section Card Widget Builder
  // ─────────────────────────────────────────────────────────────
  Widget _buildTimelineCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: EditoColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            offset: Offset(0, 8),
            blurRadius: 20,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline Title Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Timeline & Slots',
                        style: GoogleFonts.poppins(
                          color: EditoColors.dark,
                          fontSize: 15.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap on any slot to edit. Drag edges to adjust timing.',
                        style: GoogleFonts.inter(
                          color: EditoColors.body.withValues(alpha: 0.70),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => _showSlotFormDialog(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFDCCCFF)),
                      color: const Color(0xFFF7F5FF),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.add,
                          color: EditoColors.primary,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Add New Slot',
                          style: GoogleFonts.inter(
                            color: EditoColors.primary,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Ruler & Blocks Layout
            LayoutBuilder(
              builder: (context, constraints) {
                final double timelineWidth = math.max(680.0, constraints.maxWidth);
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: SizedBox(
                    width: timelineWidth,
                    child: Column(
                      children: [
                        _buildRulerLabels(timelineWidth),
                        const SizedBox(height: 6),
                        CustomPaint(
                          size: Size(timelineWidth, 10),
                          painter: _TimelineRulerPainter(),
                        ),
                        const SizedBox(height: 8),
                        _buildInteractiveTimelineBlocks(timelineWidth),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 14),

            // Help instruction footer
            Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: EditoColors.body.withValues(alpha: 0.60),
                  size: 14,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Shorten or extend slots by dragging the edges',
                    style: GoogleFonts.inter(
                      color: EditoColors.body.withValues(alpha: 0.65),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Custom Ticks and Slider Blocks Painter/Widget
  // ─────────────────────────────────────────────────────────────
  Widget _buildRulerLabels(double width) {
    return SizedBox(
      height: 14,
      width: width,
      child: Stack(
        children: [
          for (int i = 0; i <= 30; i += 5)
            Positioned(
              left: (i / 30.0) * width - 15,
              width: 30,
              child: Text(
                '${i}s',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: EditoColors.muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInteractiveTimelineBlocks(double totalWidth) {
    const double trackHeight = 62.0;
    const double handleWidth = 16.0;

    return SizedBox(
      height: trackHeight,
      width: totalWidth,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background track decoration
          Container(
            height: trackHeight,
            width: totalWidth,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3FA),
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          // Render Slot Blocks
          for (int i = 0; i < _slots.length; i++) ...[
            _buildSlotBlockItem(i, totalWidth, trackHeight),
          ],

          // Render Draggable Boundary Handles
          for (int i = 0; i < _slots.length - 1; i++) ...[
            _buildDraggableBoundary(i, totalWidth, trackHeight, handleWidth),
          ],
        ],
      ),
    );
  }

  Widget _buildSlotBlockItem(int index, double totalWidth, double trackHeight) {
    final slot = _slots[index];
    final double leftPct = slot.start / 30.0;
    final double widthPct = (slot.end - slot.start) / 30.0;

    final double leftPos = leftPct * totalWidth;
    final double itemWidth = widthPct * totalWidth;

    return Positioned(
      left: leftPos,
      width: itemWidth,
      height: trackHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.5, vertical: 2),
        child: GestureDetector(
          onTap: () => _showSlotFormDialog(slotToEdit: slot),
          child: Container(
            decoration: BoxDecoration(
              color: slot.tintColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: slot.borderColors, width: 1.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  slot.icon,
                  color: slot.color,
                  size: 16,
                ),
                const SizedBox(height: 3),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    slot.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: EditoColors.dark,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  '${_formatTime(slot.start)} - ${_formatTime(slot.end)}',
                  style: GoogleFonts.inter(
                    color: slot.color,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDraggableBoundary(int index, double totalWidth, double trackHeight, double handleWidth) {
    final leftPct = _slots[index].end / 30.0;
    final double leftPos = leftPct * totalWidth - handleWidth / 2;

    return Positioned(
      left: leftPos,
      top: (trackHeight - 32) / 2,
      width: handleWidth,
      height: 32,
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          final double deltaSeconds = (details.delta.dx / totalWidth) * 30.0;
          final double currentBoundary = _slots[index].end;
          final double newBoundary = currentBoundary + deltaSeconds;

          // Clamp new boundary between start of current slot (+1s) and end of next slot (-1s)
          final double minBound = _slots[index].start + 1.0;
          final double maxBound = _slots[index + 1].end - 1.0;

          double clampedBoundary = newBoundary.clamp(minBound, maxBound);

          setState(() {
            _slots[index].end = clampedBoundary;
            _slots[index + 1].start = clampedBoundary;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: _slots[index].color, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x20000000),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 1.5,
                  height: 10,
                  color: _slots[index].color,
                ),
                const SizedBox(width: 1.5),
                Container(
                  width: 1.5,
                  height: 10,
                  color: _slots[index].color,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Detected Slots List Card
  // ─────────────────────────────────────────────────────────────
  Widget _buildSlotsListCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: EditoColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            offset: Offset(0, 8),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        children: [
          // Card Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Detected Slots',
                  style: GoogleFonts.poppins(
                    color: EditoColors.dark,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '${_slots.length} Slots',
                  style: GoogleFonts.inter(
                    color: EditoColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: EditoColors.border),

          // Render List Rows
          Column(
            children: [
              for (int i = 0; i < _slots.length; i++) ...[
                _DetectedSlotRow(
                  index: i,
                  slot: _slots[i],
                  onEdit: () => _showSlotFormDialog(slotToEdit: _slots[i]),
                  onDelete: () => _deleteSlot(_slots[i]),
                ),
                if (i != _slots.length - 1)
                  const Divider(height: 1, color: Color(0xFFF1EEFF)),
              ],
            ],
          ),

          // Card Tip Footer
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: const BoxDecoration(
              color: Color(0xFFF1ECFF),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lightbulb_outline_rounded,
                  color: EditoColors.primary,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tip',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF4C44CC),
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Make sure each important element is inside a slot for better user experience.',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF5D54DF),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Stepper Flow component
// ─────────────────────────────────────────────────────────────
class _DefineSlotsSteps extends StatelessWidget {
  const _DefineSlotsSteps();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _StepIndicator(
            stepNumber: '1',
            label: 'Upload Video',
            isCompleted: true,
          ),
        ),
        _StepConnector(isCompleted: true),
        Expanded(
          child: _StepIndicator(
            stepNumber: '2',
            label: 'AI Detection',
            isCompleted: true,
          ),
        ),
        _StepConnector(isCompleted: true),
        Expanded(
          child: _StepIndicator(
            stepNumber: '3',
            label: 'Define Slots',
            isActive: true,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Video Details Info Component
// ─────────────────────────────────────────────────────────────
class _VideoDetailsInfoCard extends StatelessWidget {
  const _VideoDetailsInfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: EditoColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            offset: Offset(0, 8),
            blurRadius: 18,
          ),
        ],
      ),
      child: Row(
        children: [
          // Mini thumbnail visual
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 58,
              height: 44,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const _MiniVisualMock(),
                  Container(color: Colors.black.withValues(alpha: 0.10)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Title & Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wedding_Reel_Final.mp4',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: EditoColors.dark,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      color: EditoColors.body.withValues(alpha: 0.65),
                      size: 13,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '30 sec',
                      style: GoogleFonts.inter(
                        color: EditoColors.body.withValues(alpha: 0.70),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.hd_outlined,
                      color: EditoColors.body.withValues(alpha: 0.65),
                      size: 13,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '1080p',
                      style: GoogleFonts.inter(
                        color: EditoColors.body.withValues(alpha: 0.70),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.insert_drive_file_outlined,
                      color: EditoColors.body.withValues(alpha: 0.65),
                      size: 13,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '25 MB',
                      style: GoogleFonts.inter(
                        color: EditoColors.body.withValues(alpha: 0.70),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Interactive Mock Video Player Card
// ─────────────────────────────────────────────────────────────
class _InteractiveVideoPlayer extends StatelessWidget {
  const _InteractiveVideoPlayer({
    required this.isPlaying,
    required this.playbackTime,
    required this.onTogglePlay,
  });

  final bool isPlaying;
  final double playbackTime;
  final VoidCallback onTogglePlay;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x18000000),
              offset: Offset(0, 10),
              blurRadius: 24,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                'https://images.unsplash.com/photo-1607190074257-dd4b7af0309f?w=800&auto=format&fit=crop&q=80',
                fit: BoxFit.cover,
              ),

              // Shadow overlay
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.05),
                      Colors.black.withValues(alpha: 0.50),
                    ],
                  ),
                ),
              ),

              // Play / Pause Indicator circle overlay
              Center(
                child: GestureDetector(
                  onTap: onTogglePlay,
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.black.withValues(alpha: 0.65),
                    child: Icon(
                      isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 38,
                    ),
                  ),
                ),
              ),

              // Controls Bar Overlay
              Positioned(
                left: 14,
                right: 14,
                bottom: 14,
                child: Row(
                  children: [
                    // Play icon in bottom controls
                    GestureDetector(
                      onTap: onTogglePlay,
                      child: Icon(
                        isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Time display
                    Text(
                      _formatPlaybackTime(playbackTime),
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Progress Slider
                    Expanded(
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Container(
                            height: 3,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.35),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          // Played active progress line
                          LayoutBuilder(builder: (context, sliderConstraints) {
                            double width = sliderConstraints.maxWidth;
                            double playedWidth = (playbackTime / 30.0) * width;
                            return Container(
                              height: 3,
                              width: playedWidth,
                              decoration: BoxDecoration(
                                color: EditoColors.primary,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            );
                          }),
                          // Indicator dot thumb
                          Positioned(
                            left: (playbackTime / 30.0) * 100.0 * 0.01, // dynamic formula in builder
                            child: LayoutBuilder(builder: (context, dotConstraints) {
                              return Container(); // layout builder handles thumb
                            }),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),

                    // End duration
                    Text(
                      '00:30',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Fullscreen
                    Icon(
                      Icons.fullscreen_rounded,
                      color: Colors.white.withValues(alpha: 0.85),
                      size: 24,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatPlaybackTime(double time) {
    int minutes = (time / 60).floor();
    int seconds = (time % 60).floor();
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

// ─────────────────────────────────────────────────────────────
// Timeline Custom Ruler Painter
// ─────────────────────────────────────────────────────────────
class _TimelineRulerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = EditoColors.border
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final paintTick = Paint()
      ..color = EditoColors.muted.withValues(alpha: 0.4)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw main bottom horizontal line
    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, size.height),
      paintLine,
    );

    // Draw 30 ticks (one tick per second)
    double tickSpacing = size.width / 30.0;
    for (int i = 0; i <= 30; i++) {
      double x = i * tickSpacing;
      bool isMajor = i % 5 == 0;
      double tickHeight = isMajor ? 8.0 : 4.0;
      canvas.drawLine(
        Offset(x, size.height),
        Offset(x, size.height - tickHeight),
        isMajor ? (paintLine..color = EditoColors.muted.withValues(alpha: 0.8)) : paintTick,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────
// Detected Slot List Row Widget
// ─────────────────────────────────────────────────────────────
class _DetectedSlotRow extends StatelessWidget {
  const _DetectedSlotRow({
    required this.index,
    required this.slot,
    required this.onEdit,
    required this.onDelete,
  });

  final int index;
  final SlotModel slot;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    double duration = slot.end - slot.start;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Icon Box
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: slot.tintColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              slot.icon,
              color: slot.color,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),

          // Numeric badge
          CircleAvatar(
            radius: 10,
            backgroundColor: slot.color,
            child: Text(
              '${index + 1}',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Metadata Name & Type
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  slot.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: EditoColors.dark,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  slot.type,
                  style: GoogleFonts.inter(
                    color: EditoColors.body.withValues(alpha: 0.65),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Timing span & exact duration
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${_formatTime(slot.start)} - ${_formatTime(slot.end)}',
                  style: GoogleFonts.inter(
                    color: EditoColors.dark,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${duration.toStringAsFixed(0)} sec',
                  style: GoogleFonts.inter(
                    color: EditoColors.body.withValues(alpha: 0.65),
                    fontSize: 11.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Edit Action Button
          GestureDetector(
            onTap: onEdit,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFDCCCFF)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.edit_outlined,
                    color: EditoColors.primary,
                    size: 13,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Edit',
                    style: GoogleFonts.inter(
                      color: EditoColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Delete Action Button
          GestureDetector(
            onTap: onDelete,
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFFD1D1)),
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: Color(0xFFFF4D4D),
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper formatting seconds into MM:SS
String _formatTime(double seconds) {
  int mins = (seconds / 60).floor();
  int secs = (seconds % 60).round();
  return '$mins:${secs.toString().padLeft(2, '0')}';
}

// ─────────────────────────────────────────────────────────────
// Slot Model Data definition
// ─────────────────────────────────────────────────────────────
class SlotModel {
  final String id;
  String name;
  String type;
  IconData icon;
  double start;
  double end;
  Color color;
  Color tintColor;
  Color borderColors;

  SlotModel({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
    required this.start,
    required this.end,
    required this.color,
    required this.tintColor,
    required this.borderColors,
  });
}

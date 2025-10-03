import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/domain/entities/radio_station.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/presentation/blocs/cubit/radio_cubit.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/presentation/blocs/state/radio_state.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/presentation/pages/radio_page.dart';

class MockRadioCubit extends Mock implements RadioCubit {}

void main() {
  group('RadioPage', () {
    late MockRadioCubit mockRadioCubit;

    const testStation = RadioStation(
      id: 'test',
      title: 'Test Radio',
      url: 'https://test.com/stream',
      imagePath: 'assets/test.png',
    );

    setUp(() {
      mockRadioCubit = MockRadioCubit();
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: BlocProvider<RadioCubit>(
          create: (context) => mockRadioCubit,
          child: const RadioPage(),
        ),
      );
    }

    group('RadioInitial state', () {
      testWidgets('displays initial state UI', (WidgetTester tester) async {
        when(() => mockRadioCubit.state).thenReturn(const RadioInitial());

        await tester.pumpWidget(createWidgetUnderTest());

        expect(
          find.text('Select a radio station to start listening'),
          findsOneWidget,
        );
        expect(find.text('Play Default Radio'), findsOneWidget);
        expect(find.byIcon(Icons.radio), findsOneWidget);
      });

      testWidgets('calls playRadio when Play Default Radio button is tapped',
          (WidgetTester tester) async {
        when(() => mockRadioCubit.state).thenReturn(const RadioInitial());
        when(() => mockRadioCubit.playRadio(any())).thenAnswer((_) async {});

        await tester.pumpWidget(createWidgetUnderTest());

        await tester.tap(find.text('Play Default Radio'));
        await tester.pump();

        verify(() => mockRadioCubit.playRadio(any())).called(1);
      });
    });

    group('RadioLoading state', () {
      testWidgets('displays loading indicator', (WidgetTester tester) async {
        when(() => mockRadioCubit.state).thenReturn(const RadioLoading());

        await tester.pumpWidget(createWidgetUnderTest());

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    group('RadioLoaded state', () {
      testWidgets('displays loaded state UI', (WidgetTester tester) async {
        when(() => mockRadioCubit.state).thenReturn(
          const RadioLoaded(
            currentStation: testStation,
            isPlaying: true,
            volume: 50,
          ),
        );

        await tester.pumpWidget(createWidgetUnderTest());

        expect(find.text('Test Radio'), findsOneWidget);
        expect(find.byIcon(Icons.pause_rounded), findsOneWidget);
        expect(find.byType(Slider), findsOneWidget);
      });

      testWidgets('displays play icon when not playing',
          (WidgetTester tester) async {
        when(() => mockRadioCubit.state).thenReturn(
          const RadioLoaded(
            currentStation: testStation,
            isPlaying: false,
            volume: 50,
          ),
        );

        await tester.pumpWidget(createWidgetUnderTest());

        expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
      });

      testWidgets('calls togglePlayPause when control button is tapped',
          (WidgetTester tester) async {
        when(() => mockRadioCubit.state).thenReturn(
          const RadioLoaded(
            currentStation: testStation,
            isPlaying: true,
            volume: 50,
          ),
        );
        when(() => mockRadioCubit.togglePlayPause()).thenAnswer((_) async {});

        await tester.pumpWidget(createWidgetUnderTest());

        await tester.tap(find.byIcon(Icons.pause_rounded));
        await tester.pump();

        verify(() => mockRadioCubit.togglePlayPause()).called(1);
      });

      testWidgets('calls setVolume when slider is moved',
          (WidgetTester tester) async {
        when(() => mockRadioCubit.state).thenReturn(
          const RadioLoaded(
            currentStation: testStation,
            isPlaying: true,
            volume: 50,
          ),
        );
        when(() => mockRadioCubit.setVolume(any())).thenAnswer((_) async {});

        await tester.pumpWidget(createWidgetUnderTest());

        final slider = find.byType(Slider);
        await tester.drag(slider, const Offset(50, 0));
        await tester.pump();

        verify(() => mockRadioCubit.setVolume(any())).called(1);
      });
    });

    group('RadioError state', () {
      testWidgets('displays error state UI', (WidgetTester tester) async {
        when(() => mockRadioCubit.state)
            .thenReturn(const RadioError('Test error message'));

        await tester.pumpWidget(createWidgetUnderTest());

        expect(find.text('Error: Test error message'), findsOneWidget);
        expect(find.text('Try Again'), findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
      });

      testWidgets('calls stopRadio when Try Again button is tapped',
          (WidgetTester tester) async {
        when(() => mockRadioCubit.state)
            .thenReturn(const RadioError('Test error message'));
        when(() => mockRadioCubit.stopRadio()).thenAnswer((_) async {});

        await tester.pumpWidget(createWidgetUnderTest());

        await tester.tap(find.text('Try Again'));
        await tester.pump();

        verify(() => mockRadioCubit.stopRadio()).called(1);
      });
    });

    group('Auto-play functionality', () {
      testWidgets('auto-plays after delay', (WidgetTester tester) async {
        when(() => mockRadioCubit.state).thenReturn(const RadioInitial());
        when(() => mockRadioCubit.playRadio(any())).thenAnswer((_) async {});

        await tester.pumpWidget(createWidgetUnderTest());

        // Wait for auto-play delay
        await tester.pump(const Duration(milliseconds: 600));

        verify(() => mockRadioCubit.playRadio(any())).called(1);
      });

      testWidgets('does not auto-play if widget is disposed',
          (WidgetTester tester) async {
        when(() => mockRadioCubit.state).thenReturn(const RadioInitial());
        when(() => mockRadioCubit.playRadio(any())).thenAnswer((_) async {});

        await tester.pumpWidget(createWidgetUnderTest());

        // Dispose widget before auto-play delay
        await tester.pumpWidget(const SizedBox.shrink());

        // Wait for auto-play delay
        await tester.pump(const Duration(milliseconds: 600));

        verifyNever(() => mockRadioCubit.playRadio(any()));
      });
    });

    group('App lifecycle handling', () {
      testWidgets('handles app lifecycle changes', (WidgetTester tester) async {
        when(() => mockRadioCubit.state).thenReturn(
          const RadioLoaded(
            currentStation: testStation,
            isPlaying: true,
            volume: 50,
          ),
        );
        when(() => mockRadioCubit.playRadio(any())).thenAnswer((_) async {});

        await tester.pumpWidget(createWidgetUnderTest());

        // Simulate app resume
        final binding = tester.binding;
        binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);

        await tester.pump();

        verify(() => mockRadioCubit.playRadio(testStation)).called(1);
      });
    });
  });
}

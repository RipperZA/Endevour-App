// -----------------------------------------------------------------------------
// This Dart file is an implementation of the BLoC (Business Logic Component) pattern.
// It consists of the JobDetailsBloc class that manages state and events related
// to job details and other associated classes
// in this example it is linked to job_service.dart and page_job_details.dart.
// -----------------------------------------------------------------------------

import 'dart:async';
import 'package:flutter/widgets.dart'; // Import the widgets library for the BuildContext

import '../model/JobList.dart';
import '../services/job_service.dart';

// -----------------------------------------------------------------------------
// Define the events:
// These classes are concrete implementations of JobDetailsEvent
// They represent various events that can occur in the application, such as job acceptance.
// -----------------------------------------------------------------------------

abstract class JobDetailsEvent {}

class AcceptJobEvent extends JobDetailsEvent {
  final JobList job;
  final BuildContext context;
  final JobDetailsBloc bloc; // Include the bloc reference

  AcceptJobEvent(
      {@required this.job, @required this.context, @required this.bloc});
}

class JobAcceptedSuccessEvent extends JobDetailsEvent {
  final bool shouldPop;

  JobAcceptedSuccessEvent({@required this.shouldPop});
}

class JobAcceptedFailureEvent extends JobDetailsEvent {
  final bool shouldPop;

  JobAcceptedFailureEvent({@required this.shouldPop});
}

class LaunchUrlEvent extends JobDetailsEvent {
  final double latitude;
  final double longitude;

  LaunchUrlEvent({this.latitude, this.longitude});
}

// Following are the different states that can be emitted by JobDetailsBloc.
abstract class JobDetailsState {}

class JobNotAcceptedState extends JobDetailsState {}

class JobAcceptedState extends JobDetailsState {}

class JobAcceptedSuccessState extends JobDetailsState {
  final bool shouldPop;

  JobAcceptedSuccessState({@required this.shouldPop});
}

class JobAcceptedFailureState extends JobDetailsState {
  final bool shouldPop;

  JobAcceptedFailureState({@required this.shouldPop});
}

// Class to manage states and events of job details.
class JobDetailsBloc {
  // For incoming events
  final _eventController = StreamController<JobDetailsEvent>();

  Sink<JobDetailsEvent> get eventSink => _eventController.sink;

  // For outgoing states
  final _stateController = StreamController<JobDetailsState>();

  Stream<JobDetailsState> get stateStream => _stateController.stream;

  JobDetailsBloc() {
    // Whenever there is a new event, we want to map it to a new state
    _eventController.stream.listen(_mapEventToState);
  }

  // Function to map events to states.
  void _mapEventToState(JobDetailsEvent event) async {
    if (event is AcceptJobEvent) {
      _acceptJob(event);
    } else if (event is LaunchUrlEvent) {
      JobService.launchURL(event.latitude, event.longitude);
    } else if (event is JobAcceptedSuccessEvent) {
      _stateController.sink
          .add(JobAcceptedSuccessState(shouldPop: event.shouldPop));
    } else if (event is JobAcceptedFailureEvent) {
      _stateController.sink
          .add(JobAcceptedFailureState(shouldPop: event.shouldPop));
    }
  }

  // Function to accept a job and handle any possible errors.
  void _acceptJob(AcceptJobEvent event) async {
    try {
      await JobService.acceptJob(event.job, event.context, event.bloc);
      _emitJobAcceptedState();
    } catch (e) {
      _emitJobAcceptedFailureState();
    }
  }

  // Function to emit a 'job accepted' state.
  void _emitJobAcceptedState() {
    _stateController.sink.add(JobAcceptedState());
  }

  // Function to emit a 'job acceptance failed' state.
  void _emitJobAcceptedFailureState() {
    _stateController.sink.add(JobAcceptedFailureState(shouldPop: true));
  }

  // Function to dispose of the stream controllers when they're no longer used.
  void dispose() {
    _eventController.close();
    _stateController.close();
  }
}

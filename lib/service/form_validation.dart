bool validateAndSave(globalFormKey) {
  final form = globalFormKey.currentState;
  if (form.validate()) {
    form.save();
    return true;
  }
  return false;
}

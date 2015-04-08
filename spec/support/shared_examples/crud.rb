shared_examples :crud do
  subject { build described_class.name.underscore.to_sym }

  before { subject.save }

  it "should create" do
    expect(subject).to be_persisted
  end

  it "should read" do
    expect(subject).to eq subject.class.unscoped.find subject.id
  end

  it "should update" do
    expect(subject.save).to eq true
  end

  it "should destroy" do
    matcher = subject.class.paranoid? ? be_deleted : be_destroyed
    expect(subject.destroy).to matcher
  end
end

require 'spec_helper'

RSpec.describe '.property' do
  let(:test_class) do
    Class.new do
      extend PropertyAccessor

      property(:foo) do
        get { @foo.upcase }
        set { |val| @foo = val }
      end
    end
  end

  it 'sets the property' do
    instance = test_class.new
    instance.foo = 'bar'
    expect(instance.foo).to eq 'BAR'
  end

  context 'when getter is not defined' do
    let(:test_class) do
      Class.new do
        extend PropertyAccessor::ClassMethods

        property(:foo) do
          set { |val| @foo = val }
        end

        def get_foo
          @foo
        end
      end
    end

    it 'sets the setter only' do
      instance = test_class.new
      instance.foo = 'bar'
      expect(instance.get_foo).to eq 'bar'
      expect(instance.respond_to?(:foo)).to eq false
    end
  end

  context 'when getter definition is not provided' do
    let(:test_class) do
      Class.new do
        extend PropertyAccessor::ClassMethods

        property(:foo) do
          set { |val| @foo = 'foo' }
          get
        end

      end
    end

    it 'behaves as attr_reader' do
      instance = test_class.new
      instance.foo = 'bar'
      expect(instance.foo).to eq 'foo'
    end
  end

  context 'when setter definition is not provided' do
    let(:test_class) do
      Class.new do
        extend PropertyAccessor::ClassMethods

        property(:foo) do
          set
          get { @foo.upcase }
        end

      end
    end

    it 'behaves as attr_writer' do
      instance = test_class.new
      instance.foo = 'bar'
      expect(instance.foo).to eq 'BAR'
    end
  end

  context 'when setter is not defined' do
    let(:test_class) do
      Class.new do
        extend PropertyAccessor::ClassMethods

        property(:foo) do
          get { @foo.upcase }
        end

        def set_foo(val)
          @foo = val
        end
      end
    end

    it 'sets the getter only' do
      instance = test_class.new
      instance.set_foo('bar')
      expect(instance.foo).to eq 'BAR'
      expect(instance.respond_to?(:foo=)).to eq false
    end
  end

  context 'when nothing defined' do
    let(:test_class) do
      Class.new do
        extend PropertyAccessor

        property(:foo)

        def set_foo(val)
          @foo = val
        end
      end
    end

    it 'raises error' do
      instance = test_class.new
      expect(true).to eq false
    rescue PropertyAccessor::UndefinedPropertyError
    end
  end

  context 'with patched Class object' do
    let(:test_class) do
      Class.new do
        property(:foo) do
          get { @foo }
          set { |val| @foo = val }
        end
      end
    end

    it 'sets the property' do
      PropertyAccessor::Mixin.inject!
      instance = test_class.new
      instance.foo = 'bar'
      expect(instance.foo).to eq 'bar'
    end
  end

  context 'when default value provided' do
    let(:test_class) do
      Class.new do
        extend PropertyAccessor

        property(:foo) do
          default('baz')
          get { @foo }
          set { |val| @foo = val }
        end
      end
    end

    it 'returns default value' do
      instance = test_class.new
      expect(instance.foo).to eq 'baz'
      instance.foo = 'bar'
      expect(instance.foo).to eq 'bar'
    end

  end

  context 'when default value provided as block' do
    let(:test_class) do
      Class.new do
        extend PropertyAccessor

        property(:foo) do
          default { 'baz' }
          get { @foo }
          set { |val| @foo = val }
        end
      end
    end

    it 'returns default value' do
      instance = test_class.new
      expect(instance.foo).to eq 'baz'
      instance.foo = 'bar'
      expect(instance.foo).to eq 'bar'
    end

  end

  context 'when getter name is overriden' do
    let(:test_class) do
      Class.new do
        extend PropertyAccessor

        property(:foo) do
          default { 'baz' }
          get(:get_foo) { @foo }
          set { |val| @foo = val }
        end
      end
    end

    it 'creates a getter method with a specified name' do
      instance = test_class.new
      expect(instance.get_foo).to eq 'baz'
      instance.foo = 'bar'
      expect(instance.get_foo).to eq 'bar'
    end
  end

  context 'when setter name is overriden' do
    let(:test_class) do
      Class.new do
        extend PropertyAccessor

        property(:foo) do
          default { 'baz' }
          get { @foo }
          set(:set_foo) { |val| @foo = val }
        end
      end
    end

    it 'creates a getter method with a specified name' do
      instance = test_class.new
      expect(instance.foo).to eq 'baz'
      instance.set_foo 'bar'
      expect(instance.foo).to eq 'bar'
    end
  end

  context 'when setter name is overriden with `=``' do
    let(:test_class) do
      Class.new do
        extend PropertyAccessor

        property(:foo) do
          default { 'baz' }
          get { @foo }
          set(:foo_field=) { |val| @foo = val }
        end
      end
    end

    it 'creates a getter method with a specified name' do
      instance = test_class.new
      expect(instance.foo).to eq 'baz'
      instance.foo_field = 'bar'
      expect(instance.foo).to eq 'bar'
    end
  end

  context 'all together' do

    require 'date'

    let(:test_klass) do
      Class.new do
        extend PropertyAccessor

        property(:first_name)   { get { @name.upcase }; set(:family_name=) { |val| @name = val } }
        property(:last_name)    { get; set }
        property(:full_name)    { get { "#{first_name} #{last_name}" } }
        property(:birth_date)   { get; set { |val| @birth_date = Date.parse(val.to_s) } }
        property(:age)          { get { (Time.now - birth_date.to_time).to_i / 60 / 60 / 24 / 365 } }
        property(:confidential) { private get; public set; }
        property(:middle_name)  { get(:get_middle_name); protected set(:set_middle_name); }
        property(:meta)         { default { {} }; get }
      end
    end

    it 'works well' do
      p = test_klass.new
      p.family_name = 'john'
      expect(p.first_name).to eq 'JOHN'
      p.last_name = 'doe'
      expect(p.last_name).to eq 'doe'
      expect(p.full_name).to eq 'JOHN doe'
      p.birth_date = "1992-04-12"
      expect(p.birth_date).to eq Date.new(1992, 04, 12)
      expect(p.age).to be_a(Integer)
      expect(p.meta).to eq({})
      expect(p.private_methods).to include(:confidential)
      expect(p.methods).to include(:confidential=)
      expect(p.protected_methods).to include(:set_middle_name)
    end
  end
end

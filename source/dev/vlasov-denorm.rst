From normalized to physical units in Vlasov and multi-fluid simulations
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Very often we setup a problem in terms of non-dimensional units. An
example of one such non-dimensional units is given in :doc:`Normalized
Units <vlasov-normalizations>` notes. Here, I describe one approach to
"denormalize" the setup and create a set of dimensional values that
are perhaps easier to interpret than the non-dimensional units. This
denormalization is not unique, expressing the fact that plasma (and
fluid) equations are essentially scale-free.

As an example, consider the following fragment of a Gkeyll input file,
describing a typical problem setup.

.. code-block:: lua

    local Constants = require "Lib.Constants"
    -- Universal constants.
    epsilon0   = 1.0                         -- permittivity of free space.
    mu0        = 1.0                         -- permeability of free space.
    lightSpeed = 1.0/math.sqrt(mu0*epsilon0) -- speed of light.

    -- User inputs.
    massRatio = 1836.153
    tau       = 1.0   -- Ratio of ion to electron temperature.
    B0        = 0.25  -- Driven magnetic field amplitude.
    beta      = 0.01  -- Total plasma beta.

    ionMass   = massRatio    -- Ion mass in simulation.
    elcMass   = 1.0          -- Electron mass in simulation.
    ionCharge = 1.0          -- Ion charge in simulation.
    elcCharge = -1.0         -- Electron charge in simulation.

    n   = 0.01                            -- Plasma density, same for ions and electrons.
    Te  = beta*(B0^2)/(2.0*mu0*(1.0+tau)) -- Electron temperature.
    Ti  = tau*Te                          -- Ion temperature.

    -- Derived parameters.
    vtElc   = math.sqrt(2.0*Te/elcMass)
    vtIon   = math.sqrt(2.0*Ti/ionMass)

    -- cyclotron frequency
    omegaCe = ionCharge*B0/elcMass

    -- gyro radius
    rhoe = vtElc/omegaCe

    Lx = 200.0*math.pi*rhoe

    nuElc = 0.1*w0*(math.pi^2) -- Electron collision frequency.
    nuIon = nuElc/math.sqrt(ionMass*(tau^3))   -- Ion collision frequency.

    wpe = math.sqrt(n*elcCharge^2/(elcMass*epsilon0)) -- plasma frequency
	
What do these numbers mean? For example, in the abover we set :math:`n
= 0.01`. Obviously, this does not mean that there are :math:`1/100`
particles per meter! If it did, then if our cell-size was say 1/10 of
a meter, then we would have hardly any particles in a single cell. In
fact, we could no longer treat the problem with a Vlasov equation but
would need to use a N-body description instead. So how to interpret
these numbers?

First, recall that these are *non-dimensional* quantities. Hence,
these numbers do not have any units and can't be interpreted as if
they have units. To do a meaningful interpretation, we must
*denormalize* the numbers by picking some reference values. There are
several reasonable choices one can make. For example, one can choose a
reference frequency. Given the speed of light in SI units we can then
determine the reference length scale. Then, using SI units values for
electron mass, fundamental charge and other quantities, allows us to
completely denormalize all values. Of course, other reasonable choices
are possible too. For example, we can select a reference length and
then use the speed of light to determine the reference time
(frequency) unit.

In the following fragment, we select our plasma-frequency as
:math:`\omega_{pe} = 1e10 [1/s]`, and the compute a reference
frequency and, using speed of light, a length-scale:

.. code-block:: lua

    wpePhys = 1e10 -- Plasma-frequency in [1/s]
    WDIM = wpePhys/wpe -- Reference frequency [1/s]
    CDIM = Constants.SPEED_OF_LIGHT -- Reference speed
    LDIM = CDIM/WDIM -- Reference length scale

Now, all other quantities can be computed:

.. code-block:: lua

    nPhys = wpePhys^2*Constants.ELECTRON_MASS*Constants.EPSILON0/Constants.ELEMENTARY_CHARGE^2
    lambdaDPhys = vtElc/wpe*LDIM
    OmegaCePhys = omegaCe*WDIM
    B0Phys = OmegaCePhys*Constants.ELECTRON_MASS/Constants.ELEMENTARY_CHARGE
    vAlfPhys = B0Phys/math.sqrt(Constants.MU0*Constants.ELECTRON_MASS*massRatio*nPhys)

Note we use physical SI unit values of electron mass, elementary
charge, :math:`\epsilon_0` and :math:`\mu_0`. With this, the various
physical values are:

.. code-block:: lua

   Number density 3.14208e+16 [#/m^3]
   Electron thermal speed 5.29963e+06 [m/s]
   Ion thermal speed 123678 [m/s]
   Debye length 0.000529963 [m]
   Electron gyro-radius 0.000211985 [m]
   Domain length 0.133194 [m]
   Plasma parameter 4.67686e+06 [#]
   B0 0.142141 [T]
   vAlf/c 0.0583426

These numbers appear perfectly reasonable. For example, the plasma
parameter, i.e. the number of particles inside a Debye sphere, is
computed as :math:`n \lambda_D^3 = 4.7\times 10^{6}`, showing that the
plasma approximaion is perfectly valid.

Of course, other choices of the initial plasma-frequency (or another
choice of a particular physical parameter like the domain size or
number-density) would give a different set of values. However, of
course, independent of the choice, the physics remains unchanged as
long as all physical dimensions are scaled consistently. (Which is of
course the virtue of the non-dimensions units in the first place).


